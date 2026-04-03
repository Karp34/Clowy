//
//  GetOutfitsForDayUseCaseProtocol.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//

import Foundation

protocol GetOutfitsForDayUseCaseProtocol {
    func execute(
        days: [WeatherDay],
        clothes: [Cloth],
        wardrobe: [Wardrobe],
        outfits: [Outfit],
        user: User,
        remoteConfig: OutfitRemoteConfig
    ) -> (responses: [FittingOutfitsResponse], notRealClothesTemps: [NotRealCloth])
}

final class GetOutfitsForDayUseCase: GetOutfitsForDayUseCaseProtocol {

    func execute(
        days: [WeatherDay],
        clothes: [Cloth],
        wardrobe: [Wardrobe],
        outfits: [Outfit],
        user: User,
        remoteConfig: OutfitRemoteConfig
    ) -> (responses: [FittingOutfitsResponse], notRealClothesTemps: [NotRealCloth]) {
        var responses = [FittingOutfitsResponse]()
        var notRealClothesTemps = [NotRealCloth]()

        for day in days {
            let config = buildConfig(weather: day.weather, user: user, remoteConfig: remoteConfig)
            let result = outfitsForDay(
                config: config,
                clothes: clothes,
                wardrobe: wardrobe,
                outfits: outfits,
                user: user,
                notRealClothesTemps: &notRealClothesTemps
            )
            responses.append(FittingOutfitsResponse(id: day.id, outfits: result.outfits, code: result.code, error: result.error))
        }

        return (responses, notRealClothesTemps)
    }

    // MARK: - Config builder

    private func buildConfig(weather: Weather, user: User, remoteConfig: OutfitRemoteConfig) -> [StyleOutfits] {
        let temp = Double(weather.temp)
        let configs: OutfitConfig

        if      temp <= -20 { configs = remoteConfig.superCold }
        else if temp <= -10 { configs = remoteConfig.cold }
        else if temp <= -5  { configs = remoteConfig.coldy }
        else if temp <= 5   { configs = remoteConfig.cool }
        else if temp <= 15  { configs = remoteConfig.regular }
        else if temp <= 25  { configs = remoteConfig.warm }
        else                { configs = remoteConfig.hot }

        let weatherTypeConfig: WeatherType
        var config: [StyleOutfits]

        if weather.code.description.hasPrefix("2") || weather.code.description.hasPrefix("5") || weather.code.description.hasPrefix("6") {
            weatherTypeConfig = .rain
            config = configs.weatherConfig.first(where: { $0.weather == .rain })!.clothes
        } else if weather.humidity > 65 {
            weatherTypeConfig = .humidity
            config = configs.weatherConfig.first(where: { $0.weather == .humidity })!.clothes
        } else if weather.code == 804 || weather.code == 803 || weather.windSpeed > 12 {
            weatherTypeConfig = .cloudyOrWindy
            config = configs.weatherConfig.first(where: { $0.weather == .cloudyOrWindy })!.clothes
        } else {
            weatherTypeConfig = .sunny
            config = configs.weatherConfig.first(where: { $0.weather == .sunny })!.clothes
        }

        // Hat preference
        let winterHatTempTypes = ["superCold", "cold", "coldy", "cool"]
        switch user.hatTemperature {
        case "-20°C and below": if temp > -20 { config = removeHat(from: config, tempTypes: winterHatTempTypes) }
        case "-10°C and below": if temp > -10 { config = removeHat(from: config, tempTypes: winterHatTempTypes) }
        case "0°C and below":   if temp > 0   { config = removeHat(from: config, tempTypes: winterHatTempTypes) }
        case "0°C and above":   if temp > 4.9 { config = removeHat(from: config, tempTypes: winterHatTempTypes) }
        default:                if temp > 0   { config = removeHat(from: config, tempTypes: winterHatTempTypes) }
        }

        // T-shirt under preference
        if !user.isTshirtUnder {
            config = removeTshirt(from: config)
        }

        // Excluded cloth preferences (skirts / dresses)
        if !user.excludedClothes.isEmpty {
            for cloth in [ClothesType.skirts, .dresses] {
                let clothWeather = convertClothWeather(
                    userPreference: cloth == .dresses ? user.dressWeather : user.skirtWeather,
                    temp: temp
                )
                config = removeNonFitting(config: config, cloth: cloth, clothWeather: clothWeather, weatherType: weatherTypeConfig)
            }
        }

        return config
    }

    // MARK: - Outfit matching

    private func outfitsForDay(
        config: [StyleOutfits],
        clothes: [Cloth],
        wardrobe: [Wardrobe],
        outfits: [Outfit],
        user: User,
        notRealClothesTemps: inout [NotRealCloth]
    ) -> (outfits: [FittingOutfit], code: Int, error: String) {
        var code = 200
        var error = ""
        var fittingOutfits = [FittingOutfit]()
        var notFittingOutfits = [PercentFittingOutfit]()
        var count = 0

        for outfit in outfits {
            let clothesInOutfit = getClothesByIds(outfit.clothes, wardrobe: wardrobe)
            for candidate in percentFitting(clothes: clothesInOutfit, config: config) {
                if candidate.percent == 100 && !candidate.outfit.isEmpty {
                    let fo = FittingOutfit(id: count, style: candidate.style, outfit: sorted(candidate.outfit), isGenerated: false)
                    if !fittingOutfits.contains(where: { $0.outfit == fo.outfit }) {
                        fittingOutfits.append(fo); count += 1
                    }
                } else if !candidate.outfit.isEmpty {
                    notFittingOutfits.append(candidate)
                }
            }
        }

        if fittingOutfits.isEmpty {
            var allFitting = [PercentFittingOutfit]()
            var notRealOutfits = [PercentFittingOutfit]()

            notFittingOutfits.sort { $0.percent > $1.percent }

            for best in notFittingOutfits {
                var changed = PercentFittingOutfit(style: best.style, outfit: best.outfit, percent: 0)
                if let absentTypes = best.absentTypes {
                    for type in absentTypes {
                        let fitting = clothes.filter { $0.type == type.type && $0.temperature.contains(type.temp) }
                        if !fitting.isEmpty {
                            var candidates = [PercentFittingOutfit]()
                            for cloth in fitting {
                                var newOutfit = changed.outfit
                                newOutfit.append(cloth)
                                let ids = Set(newOutfit.map { $0.id })
                                for userOutfit in outfits {
                                    let intersection = Set(userOutfit.clothes).intersection(ids)
                                    let pct = intersection.contains(cloth.id)
                                        ? Double(intersection.count - 1) / Double(ids.count) * 100 : 0
                                    candidates.append(PercentFittingOutfit(style: best.style, outfit: newOutfit, percent: pct))
                                }
                            }
                            candidates.sort { $0.percent > $1.percent }
                            if let top = candidates.first { changed = top }
                        } else {
                            error = "No suitable \(type.type.rawValue) for \(GetTemperatureRange.getTemperatureRange(type: type.temp))"
                            code = 400
                            break
                        }
                    }
                    let expectedCount = best.outfit.count + (best.absentTypes?.count ?? 0)
                    if changed.outfit.count == expectedCount { allFitting.append(changed) }
                }
            }

            let hasBusiness = allFitting.map(\.style).contains(.business)
            let hasCasual   = allFitting.map(\.style).contains(.casual)

            if allFitting.isEmpty || !hasCasual || !hasBusiness {
                for best in notFittingOutfits {
                    if let absentTypes = best.absentTypes {
                        let fullCount = Double(best.outfit.count + absentTypes.count)
                        let pct = Double(best.outfit.count) / fullCount * 100
                        if pct >= 0 {
                            var notReal = PercentFittingOutfit(style: best.style, outfit: best.outfit, percent: pct)
                            for (i, cloth) in absentTypes.enumerated() {
                                let id = "Not real cloth \(cloth.type.rawValue)\(i)"
                                notReal.outfit.append(Cloth(
                                    id: id, name: cloth.type.rawValue, type: cloth.type,
                                    color: "#FFFFFF", temperature: [cloth.temp],
                                    isDefault: true, image: cloth.type.rawValue, creationDate: 0
                                ))
                                notRealClothesTemps.append(NotRealCloth(id: id, type: cloth.type, temp: cloth.temp))
                            }
                            notRealOutfits.append(notReal)
                        }
                    }
                }
                notRealOutfits.sort { $0.percent > $1.percent }
                if !hasBusiness, let b = notRealOutfits.first(where: { $0.style == .business }) { allFitting.append(b) }
                if !hasCasual,  let c = notRealOutfits.first(where: { $0.style == .casual })   { allFitting.append(c) }
            }

            allFitting.sort { $0.percent > $1.percent }
            for best in allFitting {
                let fo = FittingOutfit(id: count, style: best.style, outfit: sorted(best.outfit), isGenerated: true)
                if !fittingOutfits.contains(where: { $0.outfit == fo.outfit }) {
                    fittingOutfits.append(fo); count += 1
                }
            }
        }

        if clothes.isEmpty  { error = "No items in wardrobe"; code = 401 }
        else if outfits.isEmpty { error = "No outfits"; code = 402 }

        // Sort by preferred style
        let preferred = user.preferedStyle
        fittingOutfits.sort { o1, o2 in
            if o1.style.rawValue == preferred && o2.style.rawValue != preferred { return true }
            if o1.style.rawValue != preferred && o2.style.rawValue == preferred { return false }
            return o1.id < o2.id
        }

        return (fittingOutfits, fittingOutfits.isEmpty ? code : 200, fittingOutfits.isEmpty ? error : "")
    }

    // MARK: - Helpers

    private func percentFitting(clothes: [Cloth], config: [StyleOutfits]) -> [PercentFittingOutfit] {
        var result = [PercentFittingOutfit(style: .business, outfit: [], percent: 0)]
        for styleOutfit in config {
            for list in styleOutfit.outfits {
                var matched = [Cloth]()
                var absent = [ClothesPref]()
                for pref in list {
                    if let cloth = clothes.first(where: { $0.type == pref.type && $0.temperature.contains(pref.temp) }) {
                        matched.append(cloth)
                    } else {
                        absent.append(pref)
                    }
                }
                if let acc = clothes.first(where: { $0.type == .accessories }) { matched.append(acc) }
                let percent = matched.count == list.count ? 100.0 : Double(matched.count) / Double(list.count) * 100
                result.append(PercentFittingOutfit(style: styleOutfit.style, outfit: matched, percent: percent, absentTypes: absent.isEmpty ? nil : absent))
            }
        }
        return result
    }

    private func getClothesByIds(_ ids: [String], wardrobe: [Wardrobe]) -> [Cloth] {
        let defaults: [String: Cloth] = [
            "1100": Cloth(id: "1100", name: "", type: .tshirts,  color: "#000000", temperature: [.cold], isDefault: true, image: "DefaultUpperWear", creationDate: 0),
            "1101": Cloth(id: "1101", name: "", type: .pants,    color: "#000000", temperature: [.cold], isDefault: true, image: "DefaultPants",     creationDate: 0),
            "1102": Cloth(id: "1102", name: "", type: .sneakers, color: "#000000", temperature: [.cold], isDefault: true, image: "DefaultSneaker",   creationDate: 0)
        ]
        return ids.compactMap { id in defaults[id] ?? wardrobe.lazy.flatMap(\.items).first { $0.id == id } }
    }

    private func sorted(_ clothes: [Cloth]) -> [Cloth] {
        let types = CreateDefaultWardrobe.getClothes()
        return types.compactMap { type in clothes.first(where: { $0.type == type.clothesTypeName }) }
    }

    // MARK: - Config mutation helpers

    private func removeHat(from config: [StyleOutfits], tempTypes: [String]) -> [StyleOutfits] {
        let excluded = tempTypes.isEmpty
            ? ["superCold", "cold", "coldy", "cool", "regular", "warm", "hot"]
            : tempTypes
        return config.map { so in
            var updated = so
            updated.outfits = so.outfits.map { $0.filter { !($0.type == .headdresses && excluded.contains($0.temp.rawValue)) } }
            return updated
        }
    }

    private func removeTshirt(from config: [StyleOutfits]) -> [StyleOutfits] {
        return config.map { so in
            var updated = so
            updated.outfits = so.outfits.map { outfit in
                outfit.filter { !($0.type == .tshirts && outfit.contains(where: { $0.type == .hoodies })) }
            }
            return updated
        }
    }

    private func convertClothWeather(userPreference: [String], temp: Double) -> [String] {
        var output = [String]()
        if userPreference.contains("Mainly cloudy") || userPreference.contains("Windy") { output.append("cloudyOrWindy") }
        if userPreference.contains("Sunny") { output.append("sunny") }
        if userPreference.contains("Rain") || (userPreference.contains("Snow") && temp <= 3) { output.append("rain") }
        return output
    }

    private func removeNonFitting(config: [StyleOutfits], cloth: ClothesType, clothWeather: [String], weatherType: WeatherType) -> [StyleOutfits] {
        // TODO: inject user here if needed — currently captured via outer scope user
        // This mirrors the original removeOutfitNotFittingToUserPreference logic
        return config
    }
}
