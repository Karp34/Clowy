//
//  CameraViewModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 25.03.2026.
//

import UIKit

// Manages UI state for the camera screen.
// Has no knowledge of AVFoundation — all hardware access goes through `TakePhotoUseCase`.
@MainActor
final class CameraViewModel: ObservableObject {

    // MARK: - Published state

    // Whether a photo has been taken and is pending review.
    @Published private(set) var capturedImage: UIImage?

    // Whether the captured image has been saved to the photo library.
    @Published private(set) var isSaved = false

    // Set to `true` when the user has denied camera access.
    @Published var showPermissionAlert = false

    // The latest capture error, presented as an alert by the View.
    @Published var captureError: CameraServiceError?

    // MARK: - Dependencies

    private let takePhotoUseCase: TakePhotoUseCase
    let cameraService: CameraServiceProtocol

    // MARK: - Init

    init(takePhotoUseCase: TakePhotoUseCase, cameraService: CameraServiceProtocol) {
        self.takePhotoUseCase = takePhotoUseCase
        self.cameraService = cameraService
    }

    convenience init() {
        let service = CameraService()
        self.init(
            takePhotoUseCase: TakePhotoUseCase(cameraService: service),
            cameraService: service
        )
    }

    // MARK: - Lifecycle

    // Call from the View's `task`. Requests camera access and, if granted, starts the session.
    // Session start is here — after permission — so the preview layer receives frames immediately.
    func onAppear() async {
        let granted = await cameraService.requestAccess()
        if granted {
            cameraService.startSession()
        } else {
            showPermissionAlert = true
        }
    }

    // Call from the View's `onDisappear` to release the camera session.
    func onDisappear() {
        cameraService.stopSession()
    }

    // MARK: - Actions

    // Captures a photo and stores it in `capturedImage`.
    func takePhoto() async {
        do {
            let image = try await takePhotoUseCase.execute()
            capturedImage = image
            cameraService.stopSession()
        } catch let error as CameraServiceError {
            captureError = error
        } catch {
            captureError = .captureFailed(error.localizedDescription)
        }
    }

    // Discards the current photo and restarts the camera session.
    func retake() {
        capturedImage = nil
        isSaved = false
        cameraService.startSession()
    }

    // Saves the current `capturedImage` to the user's photo library.
    func savePhoto() {
        guard let image = capturedImage else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        isSaved = true
    }
}
