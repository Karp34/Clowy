//
//  UploadClothImageUseCase.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import UIKit

final class UploadClothImageUseCase {
    private let repository: ICreateClothRepository

    init(repository: ICreateClothRepository) {
        self.repository = repository
    }

    func execute(image: UIImage, fileName: String) async throws {
        guard let data = image.jpegData(compressionQuality: 0.5) else {
            throw UploadImageError.invalidImage
        }
        try await repository.uploadImage(data: data, fileName: fileName)
    }
}

enum UploadImageError: Error {
    case invalidImage
}
