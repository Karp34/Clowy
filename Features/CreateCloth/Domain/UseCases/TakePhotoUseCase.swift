//
//  TakePhotoUseCase.swift
//  Clowy
//
//  Created by Егор Карпухин on 25.03.2026.
//

import UIKit

// Captures a photo via the camera and returns it as a `UIImage`.
// This is the only entry point for photo capture in the CreateCloth feature —
// all AVFoundation details stay behind `CameraServiceProtocol`.
final class TakePhotoUseCase {

    private let cameraService: CameraServiceProtocol

    init(cameraService: CameraServiceProtocol) {
        self.cameraService = cameraService
    }

    // Captures a photo and decodes the raw data into a `UIImage`.
    // Throws `CameraServiceError` if capture fails or data cannot be decoded.
    func execute() async throws -> UIImage {
        let data = try await cameraService.capturePhoto()

        guard let image = UIImage(data: data) else {
            throw CameraServiceError.noDataReturned
        }

        return image
    }
}
