//
//  Temperature.swift
//  Clowy
//
//  Created by Егор Карпухин on 30.06.2022.
//

import SwiftUI

struct Temperature: Identifiable, Equatable {
    var id: Int
    var name: String
    var temp: [Int]
}

enum TemperatureType: String, Codable {
    case superCold = "superCold"
    case cold = "cold"
    case coldy = "coldy"
    case cool = "cool"
    case regular = "regular"
    case warm = "warm"
    case hot = "hot"
}
