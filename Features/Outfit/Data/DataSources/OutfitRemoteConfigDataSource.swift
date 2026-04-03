//
//  OutfitRemoteConfigDataSource.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import Foundation

final class OutfitRemoteConfigDataSource {

    private let remoteConfig: RemoteConfigManager

    init(remoteConfig: RemoteConfigManager = .shared) {
        self.remoteConfig = remoteConfig
    }

    func fetch() -> OutfitRemoteConfig {
        OutfitRemoteConfig(
            superCold: outfitConfig(forKey: RCKey.normalSuperColdConfig),
            cold:      outfitConfig(forKey: RCKey.normalColdConfig),
            coldy:     outfitConfig(forKey: RCKey.normalColdyConfig),
            cool:      outfitConfig(forKey: RCKey.normalCoolConfig),
            regular:   outfitConfig(forKey: RCKey.normalRegularConfig),
            warm:      outfitConfig(forKey: RCKey.normalWarmConfig),
            hot:       outfitConfig(forKey: RCKey.normalHotConfig)
        )
    }

    // MARK: - Private

    private func outfitConfig(forKey key: String) -> OutfitConfig {
        let data = remoteConfig.dataValue(forKey: key)
        var outfitConfig = OutfitConfig(name: "", weatherConfig: [])
        guard
            let json = try? JSONSerialization.jsonObject(with: data),
            let dict = json as? [String: Any]
        else { return outfitConfig }

        outfitConfig.name = dict["name"] as? String ?? ""

        if let config = dict["config"] as? [String: [String: [[String: String]]]] {
            for (weatherKey, styles) in config {
                guard let weather = WeatherType(rawValue: weatherKey) else { continue }
                var weatherOutfits: [StyleOutfits] = []

                for (styleKey, outfits) in styles {
                    guard let styleName = OutfitStyle(rawValue: styleKey) else { continue }
                    let clothesPrefs: [[ClothesPref]] = outfits.map { outfit in
                        outfit.compactMap { (clothKey, tempValue) in
                            guard
                                let clothType = ClothesType(rawValue: clothKey),
                                let temp = TemperatureType(rawValue: tempValue)
                            else { return nil }
                            return ClothesPref(type: clothType, temp: temp)
                        }
                    }
                    weatherOutfits.append(StyleOutfits(style: styleName, outfits: clothesPrefs))
                }
                outfitConfig.weatherConfig.append(WeatherConfig(weather: weather, clothes: weatherOutfits))
            }
        }
        return outfitConfig
    }
}
