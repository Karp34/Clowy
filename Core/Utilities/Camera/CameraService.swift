//
//  CameraService.swift
//  Clowy
//
//  Created by Егор Карпухин on 25.03.2026.
//

@preconcurrency import AVFoundation

// Concrete AVFoundation implementation of `CameraServiceProtocol`.
// This class owns the capture session and all AVFoundation objects.
// It has no knowledge of SwiftUI or any feature-level business logic.
final class CameraService: NSObject, CameraServiceProtocol, @unchecked Sendable {

    // MARK: - Public

    let previewLayer: AVCaptureVideoPreviewLayer

    // MARK: - Private AVFoundation objects

    internal let session = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private let photoOutput = AVCapturePhotoOutput()

    // Continuation resumed when AVCapturePhotoCaptureDelegate fires.
    private var photoContinuation: CheckedContinuation<Data, Error>?

    // MARK: - Init

    override init() {
        // Build the preview layer once; it stays attached to the session for its lifetime.
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        super.init()
    }

    // MARK: - CameraServiceProtocol

    func requestAccess() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .video)
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }

    func startSession() {
        sessionQueue.async {
            guard !self.session.isRunning else { return }
            self.configureSessionIfNeeded()
            self.session.startRunning()
        }
    }
    
    func stopSession() {
        sessionQueue.async {
            guard self.session.isRunning else { return }
            self.session.stopRunning()
        }
    }

    func capturePhoto() async throws -> Data {
        // Wrap the delegate callback in a Swift Concurrency continuation.
        return try await withCheckedThrowingContinuation { continuation in
            self.photoContinuation = continuation
            let settings = AVCapturePhotoSettings()
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self else { return }
                self.photoOutput.capturePhoto(with: settings, delegate: self)
            }
        }
    }

    // MARK: - Private

    // Configures inputs and outputs once.
    // Calling it multiple times is safe — the guard at the top exits early
    // if the session already has inputs attached.
    private func configureSessionIfNeeded() {
        // Whole function shoul use sessionQueue
        guard session.inputs.isEmpty else {
            // In case coniguration was already done, but layer is not connected
            if previewLayer.session == nil {
                previewLayer.session = session
                previewLayer.videoGravity = .resizeAspectFill
            }
            return
        }

        // Prefer dual camera, fallback на wide
        let discovery = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInDualCamera, .builtInWideAngleCamera],
            mediaType: .video,
            position: .back
        )

        guard let device = discovery.devices.first else {
            photoContinuation?.resume(throwing: CameraServiceError.deviceUnavailable)
            photoContinuation = nil
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)

            session.beginConfiguration()

            if session.canSetSessionPreset(.photo) {
                session.sessionPreset = .photo
            }

            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                session.commitConfiguration()
                photoContinuation?.resume(throwing: CameraServiceError.deviceUnavailable)
                photoContinuation = nil
                return
            }

            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
            } else {
                session.commitConfiguration()
                photoContinuation?.resume(throwing: CameraServiceError.captureFailed("Cannot add photo output"))
                photoContinuation = nil
                return
            }

            session.commitConfiguration()

            previewLayer.session = session
            previewLayer.videoGravity = .resizeAspectFill

        } catch {
            session.commitConfiguration()
            photoContinuation?.resume(throwing: CameraServiceError.captureFailed(error.localizedDescription))
            photoContinuation = nil
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraService: AVCapturePhotoCaptureDelegate {

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        if let error {
            photoContinuation?.resume(throwing: CameraServiceError.captureFailed(error.localizedDescription))
            photoContinuation = nil
            return
        }

        guard let data = photo.fileDataRepresentation() else {
            photoContinuation?.resume(throwing: CameraServiceError.noDataReturned)
            photoContinuation = nil
            return
        }

        photoContinuation?.resume(returning: data)
        photoContinuation = nil
    }
}
