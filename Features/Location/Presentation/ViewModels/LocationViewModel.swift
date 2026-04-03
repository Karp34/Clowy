//
//  LocationViewModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.03.2026.
//

import SwiftUI
import CoreLocation

@MainActor
final class LocationViewModel: ObservableObject {

    // MARK: - Published

    @Published var cityNames: [String] = []
    @Published var stateCityName: PlaceHolderState = .placeholder
    @Published var useUserGeo: Bool = UserDefaults.standard.bool(forKey: "isGeoposition")
    @Published var coordinates: CLLocationCoordinate2D?
    @Published var isLoadingLocation: Bool = false

    // MARK: - Dependencies

    private let searchCitiesUseCase: SearchCitiesUseCase
    private let getCurrentLocationUseCase: GetCurrentLocationUseCase

    init(
        searchCitiesUseCase: SearchCitiesUseCase = SearchCitiesUseCase(repository: LocationRepositoryImpl()),
        getCurrentLocationUseCase: GetCurrentLocationUseCase = GetCurrentLocationUseCase(repository: LocationRepositoryImpl())
    ) {
        self.searchCitiesUseCase = searchCitiesUseCase
        self.getCurrentLocationUseCase = getCurrentLocationUseCase
    }

    // MARK: - City search

    func searchCities(prefixName: String) async {
        guard prefixName.count > 2 else { return }
        stateCityName = .placeholder
        do {
            let results = try await searchCitiesUseCase.execute(prefixName: prefixName)
            cityNames = results.map { $0.fullName }
            stateCityName = .success
        } catch {
            stateCityName = .error
            AppLogger.error(error, category: .network)
        }
    }

    // MARK: - Device location

    func requestCurrentLocation() async {
        isLoadingLocation = true
        do {
            let coord = try await getCurrentLocationUseCase.execute()
            coordinates = coord
            useUserGeo = true
            UserDefaults.standard.set(true, forKey: "isGeoposition")
        } catch {
            AppLogger.error(error, category: .general)
        }
        isLoadingLocation = false
    }

    func setManualLocation(_ city: String) {
        useUserGeo = false
        UserDefaults.standard.set(false, forKey: "isGeoposition")
        UserDefaults.standard.set(city, forKey: "location")
    }
}
