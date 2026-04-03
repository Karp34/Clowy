//
//  LocationRepositoryImpl.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import CoreLocation
import Combine

final class LocationRepositoryImpl: ILocationRepository {
    private let remoteDataSource: LocationRemoteDataSource
    private let deviceLocationService: DeviceLocationService

    init(
        remoteDataSource: LocationRemoteDataSource = LocationRemoteDataSource(),
        deviceLocationService: DeviceLocationService = DeviceLocationService()
    ) {
        self.remoteDataSource = remoteDataSource
        self.deviceLocationService = deviceLocationService
    }

    func searchCities(prefixName: String) async throws -> [LocationResult] {
        let response = try await remoteDataSource.searchCities(prefixName: prefixName)
        return response.geonames.map { geoname in
            let full = geoname.name + ", " + geoname.countryName
            let short = geoname.name + ", " + geoname.countryCode
            return LocationResult(
                name: geoname.name,
                fullName: full.count < 40 ? full : short
            )
        }
    }

    func requestLocation() async throws -> CLLocationCoordinate2D {
        deviceLocationService.requestLocation()
        return try await withCheckedThrowingContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = deviceLocationService.$coordinates
                .compactMap { $0 }
                .first()
                .sink { (coordinates: CLLocationCoordinate2D) in
                    continuation.resume(returning: coordinates)
                    cancellable?.cancel()
                }
        }
    }
}
