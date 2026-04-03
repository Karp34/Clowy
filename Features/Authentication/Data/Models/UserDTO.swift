//
//  UserDTO.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Foundation

struct UserDTO {
    let id: String
    let username: String
    let userIcon: String
    let config: String
    let didOnboarding: Bool
    let preferedStyle: String
    let hatTemperature: String
    let isTshirtUnder: Bool
    let excludedClothes: [String]
    let skirtPairings: [String]
    let skirtWeather: [String]
    let dressPairings: [String]
    let dressWeather: [String]
}
