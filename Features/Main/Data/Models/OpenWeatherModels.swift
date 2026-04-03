//
//  OpenWeatherModels.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.09.2022.
//

import SwiftUI

struct ResponseBodyWeatherAPI: Codable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var base: String
    var main: MainResponse?
    var wind: WindResponse
    var clouds: CloudsResponse
    var dt: Int
    var sys: SysResponse
    var timezone: Int
    var id: Double
    var name: String
    var cod: Double
}

struct ResponseBodyForecastAPI: Codable {
    var cod: String
    var message: Double
    var cnt: Double
    var list: [ListResponse]
    var city: CityResponse
}

struct CityResponse: Codable {
    var id: Double
    var name: String
    var coord: CoordinatesResponse?
    var country: String
    var population: Double
    var timezone: Double
    var sunrise: Double
    var sunset: Double
}

struct ListResponse: Codable {
    var dt: Int
    var main: MainResponse
    var weather: [WeatherResponse]
    var wind: WindResponse
    var clouds: CloudsResponse
    var visibility: Double?
    var pop: Double
    var sys: [ String: String ]?
    var dt_txt: String
}
    
struct CoordinatesResponse: Codable {
    var lon: Double?
    var lat: Double?
}

struct WeatherResponse: Codable, Identifiable {
    var id: Double
    var main: String
    var description: String
    var icon: String
}

struct CloudsResponse: Codable {
    var all: Double
}

struct SysResponse: Codable {
    var type: Double?
    var id: Int?
    var country: String?
    var sunrise: Double
    var sunset: Double
}

struct MainResponse: Codable {
    var temp: Double
    var feels_like: Double?
    var temp_min: Double
    var temp_max: Double?
    var pressure: Double
    var humidity: Double
    var sea_level: Double?
    var grnd_level: Double?
    var temp_kf: Double?
}

struct WindResponse: Codable {
    var speed: Double
    var deg: Double
    var gust: Double
}
