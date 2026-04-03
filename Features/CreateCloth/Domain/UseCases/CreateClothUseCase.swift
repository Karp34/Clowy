//
//  CreateClothUseCase.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Foundation

final class CreateClothUseCase {
    private let repository: ICreateClothRepository

    init(repository: ICreateClothRepository) {
        self.repository = repository
    }

    func execute(_ input: CreateClothInput) async throws {
        try await repository.createCloth(input)
    }
}
