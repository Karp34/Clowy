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
    case superCold = "SuperCold"
    case cold = "Cold"
    case coldy = "Coldy"
    case regular = "Regular"
    case warm = "Warm"
    case hot = "Hot"
}
