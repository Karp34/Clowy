//
//  User.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 02.10.2022.
//

import Foundation

struct User: Identifiable {
    var id: String
    var username: String
    var userIcon: String
    var config: String
    var didOnboarding: Bool
    var preferedStyle: String
    var hatTemperature: String
    var isTshirtUnder: Bool
    var excludedClothes: [String]
    var skirtPairings: [String]
    var skirtWeather: [String]
    var dressPairings: [String]
    var dressWeather: [String]
}
