//
//  MainScreenViewModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//

import SwiftUI

@MainActor
final class MainScreenViewModel: ObservableObject {

    // MARK: - Published state

    @Published var loadingState: MainScreenLoadingState = .placeholder
    @Published var days: [WeatherDay] = []
    @Published var selectedId: Int = 0
    @Published var chosenWeather: Weather = .default
    @Published var fittingOutfitsResponse: [FittingOutfitsResponse] = []
    @Published var notRealClothesTemps: [NotRealCloth] = []
    @Published var user: User = .empty
    private var clothes: [Cloth] = []
    @Published var wardrobe: [Wardrobe] = []
    private var outfits: [Outfit] = []
    private var remoteConfig: OutfitRemoteConfig?

    // MARK: - Dependencies

    private let fetchWeather: FetchWeatherUseCaseProtocol
    private let parseWeather: ParseWeatherUseCaseProtocol
    private let getOutfits: GetOutfitsForDayUseCaseProtocol

    // MARK: - Init

    init(
        fetchWeather: FetchWeatherUseCaseProtocol,
        parseWeather: ParseWeatherUseCaseProtocol,
        getOutfits: GetOutfitsForDayUseCaseProtocol
    ) {
        self.fetchWeather = fetchWeather
        self.parseWeather = parseWeather
        self.getOutfits = getOutfits
    }
    
    // MARK: - Public API

    // Loads weather and then resolves outfit recommendations for all days.
    func load(
        lat: Double?,
        long: Double?,
        locationName: String?,
        user: User,
        clothes: [Cloth],
        wardrobe: [Wardrobe],
        outfits: [Outfit],
        remoteConfig: OutfitRemoteConfig
    ) async {
        self.user = user
        self.clothes = clothes
        self.wardrobe = wardrobe
        self.outfits = outfits
        self.remoteConfig = remoteConfig
        loadingState = .placeholder

        do {
            let rawForecast = try await fetchWeather.execute(lat: lat, long: long, locationName: locationName)
            let parsedDays = parseWeather.execute(data: rawForecast)

            withAnimation { self.days = parsedDays }
            changeWeather(id: selectedId)

            let result = getOutfits.execute(
                days: parsedDays,
                clothes: clothes,
                wardrobe: wardrobe,
                outfits: outfits,
                user: user,
                remoteConfig: remoteConfig
            )
            fittingOutfitsResponse = result.responses
            notRealClothesTemps = result.notRealClothesTemps

            withAnimation { loadingState = .success }
        } catch {
            AppLogger.log("Weather load failed: \(error.localizedDescription)", category: .network)
            withAnimation { loadingState = .error }
            chosenWeather = .default
        }
    }
    
    func reload(lat: Double?, long: Double?, locationName: String?) async {
        guard let remoteConfig else { return }
        await load(lat: lat, long: long, locationName: locationName,
                   user: user, clothes: clothes,
                   wardrobe: wardrobe, outfits: outfits,
                   remoteConfig: remoteConfig)
    }
    
    /// Called when the user taps a different day tab.
    func changeWeather(id: Int) {
        selectedId = id
        if let weather = days.first(where: { $0.id == id })?.weather {
            chosenWeather = weather
        } else if let first = days.first {
            chosenWeather = first.weather
            selectedId = first.id
        } else {
            chosenWeather = .default
        }
    }

    // MARK: - Reset

    func reset() {
        loadingState = .placeholder
        days = []
        selectedId = 0
        chosenWeather = .default
        fittingOutfitsResponse = []
        notRealClothesTemps = []
    }
}

// MARK: - Weather default

private extension Weather {
    static let `default` = Weather(
        code: 100, name: "Clouds", color: Color.primaryGrey,
        icon: "CustomCloudIcon", temp: 0, humidity: 99, windSpeed: 2
    )
}
