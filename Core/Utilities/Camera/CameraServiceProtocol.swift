//
//  CameraServiceProtocol.swift
//  Clowy
//
//  Created by Егор Карпухин on 25.03.2026.
//

import AVFoundation

// Defines the contract for camera hardware access.
// Conforming types handle all AVFoundation internals;
// consumers (ViewModels, UseCases) never import AVFoundation directly.
protocol CameraServiceProtocol: AnyObject {
    var session: AVCaptureSession { get }

    // The preview layer to embed in a UIView for live camera feed.
    var previewLayer: AVCaptureVideoPreviewLayer { get }

    // Checks the current authorization status and requests access if needed.
    // Returns `true` if the app is authorized to use the camera.
    func requestAccess() async -> Bool

    // Configures and starts the capture session.
    // Must be called after `requestAccess()` returns `true`.
    func startSession()

    // Stops the capture session. Call when the camera UI is dismissed.
    func stopSession()

    // Captures a single photo and returns its raw `Data`.
    // Throws `CameraServiceError` if capture fails.
    func capturePhoto() async throws -> Data
}

// MARK: - Errors

enum CameraServiceError: LocalizedError, Identifiable {
    var id: String { errorDescription ?? UUID().uuidString }
    case accessDenied
    case deviceUnavailable
    case captureFailed(String)
    case noDataReturned
 
    var errorDescription: String? {
        switch self {
        case .accessDenied:
            return "Camera access was denied. Please enable it in Settings."
        case .deviceUnavailable:
            return "No suitable camera device was found on this device."
        case .captureFailed(let reason):
            return "Photo capture failed: \(reason)"
        case .noDataReturned:
            return "The camera returned no image data."
        }
    }
}
