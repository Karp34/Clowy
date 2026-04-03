//
//  ILocationRepository.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import CoreLocation

protocol ILocationRepository {
    func searchCities(prefixName: String) async throws -> [LocationResult]
    func requestLocation() async throws -> CLLocationCoordinate2D
}
