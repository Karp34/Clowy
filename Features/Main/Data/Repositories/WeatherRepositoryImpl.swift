//
//  WeatherRepositoryProtocol.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


//
//  WeatherRepository.swift
//  Clowy
//

import Foundation

// MARK: - Protocol

protocol WeatherRepositoryProtocol {
    func fetchForecast(lat: Double?, long: Double?, locationName: String?) async throws -> ResponseBodyForecastAPI
}

// MARK: - Errors

enum WeatherRepositoryError: LocalizedError {
    case missingParameters
    case invalidURL
    case noData
    case decodingFailed(Error)
    case networkError(Error)

    var errorDescription: String? {
        switch self {
        case .missingParameters:    return "Either coordinates or location name must be provided"
        case .invalidURL:           return "Failed to construct weather API URL"
        case .noData:               return "No data received from server"
        case .decodingFailed(let e): return "Decoding failed: \(e.localizedDescription)"
        case .networkError(let e):  return e.localizedDescription
        }
    }
}

// MARK: - Implementation

final class WeatherRepositoryImpl: WeatherRepositoryProtocol {

    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    func fetchForecast(lat: Double?, long: Double?, locationName: String?) async throws -> ResponseBodyForecastAPI {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")!

        if let lat, let long {
            components.queryItems = [
                URLQueryItem(name: "lat",   value: String(lat)),
                URLQueryItem(name: "lon",   value: String(long)),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric")
            ]
        } else if let locationName {
            components.queryItems = [
                URLQueryItem(name: "q",     value: locationName),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric")
            ]
        } else {
            throw WeatherRepositoryError.missingParameters
        }

        guard let url = components.url else { throw WeatherRepositoryError.invalidURL }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(ResponseBodyForecastAPI.self, from: data)
        } catch let error as DecodingError {
            throw WeatherRepositoryError.decodingFailed(error)
        } catch {
            throw WeatherRepositoryError.networkError(error)
        }
    }
}