//
//  DIContainer+Main.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//
//  Wires the Main feature module: repository → use cases → view model.

import Foundation
 
extension DIContainer {
 
    // Creates a fully wired MainScreenViewModel.
    // Call this once (e.g. in your root coordinator / App entry point) and inject via @StateObject.
    @MainActor
    func makeMainScreenViewModel() -> MainScreenViewModel {
        let apiKey = RemoteConfigManager.shared.stringValue(forKey: RCKey.openWeatherAppID)
        let repository = WeatherRepositoryImpl(apiKey: apiKey)
 
        return MainScreenViewModel(
            fetchWeather: FetchWeatherUseCase(repository: repository),
            parseWeather: ParseWeatherUseCase(),
            getOutfits: GetOutfitsForDayUseCase()
        )
    }
}
 
