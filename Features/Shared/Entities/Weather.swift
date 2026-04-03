//
//  WeatherModel.swift
//  Clowy2
//
//  Created by Егор Карпухин on 15.04.2022.
//

import SwiftUI

struct Weather: Equatable {
    var code: Double
    var name: String
    var color: Color
    var icon: String
    var temp: Int
    var humidity: Int
    var windSpeed: Int
}
