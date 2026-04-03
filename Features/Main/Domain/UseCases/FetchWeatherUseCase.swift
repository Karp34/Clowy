//
//  FetchWeatherUseCaseProtocol.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//

import Foundation

protocol FetchWeatherUseCaseProtocol {
    func execute(lat: Double?, long: Double?, locationName: String?) async throws -> ResponseBodyForecastAPI
}

final class FetchWeatherUseCase: FetchWeatherUseCaseProtocol {
    private let repository: WeatherRepositoryProtocol

    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }

    func execute(lat: Double?, long: Double?, locationName: String?) async throws -> ResponseBodyForecastAPI {
        try await repository.fetchForecast(lat: lat, long: long, locationName: locationName)
    }
}
