//
//  Untitled.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Foundation

extension User {
    static let empty = User(
        id: "",
        username: "",
        userIcon: "",
        config: "",
        didOnboarding: false,
        preferedStyle: "",
        hatTemperature: "",
        isTshirtUnder: true,
        excludedClothes: [],
        skirtPairings: [],
        skirtWeather: [],
        dressPairings: [],
        dressWeather: []
    )
}
