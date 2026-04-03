//
//  GetCurrentLocationUseCase.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import CoreLocation

final class GetCurrentLocationUseCase {
    private let repository: ILocationRepository

    init(repository: ILocationRepository) {
        self.repository = repository
    }

    func execute() async throws -> CLLocationCoordinate2D {
        try await repository.requestLocation()
    }
}
