//
//  SearchCitiesUseCase.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import Foundation

final class SearchCitiesUseCase {
    private let repository: ILocationRepository

    init(repository: ILocationRepository) {
        self.repository = repository
    }

    func execute(prefixName: String) async throws -> [LocationResult] {
        try await repository.searchCities(prefixName: prefixName)
    }
}
