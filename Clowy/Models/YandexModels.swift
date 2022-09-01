//
//  YandexModels.swift
//  Clowy
//
//  Created by Егор Карпухин on 01.09.2022.
//

import SwiftUI

struct WeatherForecastYandex: Decodable, Identifiable{
    let id = UUID()
    var now: Int?
    var now_dt: String?
    var info: InfoYandex?
    var geo_object: [String: GeoObject]?
    var yesterday: [String: Int]?
    var fact: FactYandex?
    var forecasts: [ForecastsYandex]?
}
                     
struct GeoObject: Codable {
    var id: Int?
    var name: String?
}

struct InfoYandex: Codable {
    var n: Bool?
    var geoid: Int?
    var url: String?
    var lat: Double?
    var lon: Double?
    var tzinfo: TzinfoYandex?
    var def_pressure_mm: Int?
    var def_pressure_pa: Int?
    var slug: String?
    var zoom: Int?
    var nr: Bool?
    var ns: Bool?
    var nsr: Bool?
    var p: Bool?
    var f: Bool?
    var _h: Bool?
}

struct TzinfoYandex: Codable {
    var name: String?
    var abbr: String?
    var dst: Bool?
    var offset: Int?
}

struct FactYandex: Codable {
    
    var obs_time: Int?
    var uptime: Int?
    var temp: Int?
    var feels_like: Int?
    var icon: String?
    var condition: String?
    var cloudness: Double?
    var prec_type: Int?
    var prec_prob: Int?
    var prec_strength: Int?
    var is_thunder: Bool?
    var wind_speed: Double?
    var dir: String?
    var pressure_mm: Int?
    var pressure_pa: Int?
    var humidity: Int?
    var daytime: String?
    var polar: Bool?
    var season: String?
    var source: String?
    var accum_prec: [String: Int]?
    var soil_moisture: Double?
    var soil_temp: Int?
    var uv_index: Int?
    var wind_gust: Double?
}

struct ForecastsYandex: Codable, Identifiable {
    let id = UUID()
    var date: String?
    var date_ts: Int?
    var week: Int?
    var sunrise: String?
    var sunset: String?
    var rise_begin: String?
    var set_end: String?
    var moon_code: Int?
    var moon_text: String?
    var parts: [String: PartsYandex]?
    var hours: [HoursYandex]?
    var biomet: BiometYandex?
}
      
struct PartsYandex: Codable {
    var _source: String?
    var temp: Int?
    var temp_min: Int?
    var temp_avg: Int?
    var temp_max: Int?
    var wind_speed: Double?
    var wind_gust: Double?
    var wind_dir: String?
    var pressure_mm: Int?
    var pressure_pa: Int?
    var humidity: Int?
    var soil_temp: Int?
    var soil_moisture: Double?
    var prec_mm: Double?
    var prec_prob: Int?
    var prec_period: Int?
    var cloudness: Double?
    var prec_type: Int?
    var prec_strength: Double?
    var icon: String?
    var condition: String?
    var uv_index: Int?
    var feels_like: Int?
    var daytime: String?
    var polar: Bool?
}
      
struct HoursYandex: Codable {
    var hour: String?
    var hour_ts: Int?
    var temp: Int?
    var feels_like: Int?
    var icon: String?
    var condition: String?
    var cloudness: Double?
    var prec_type: Int?
    var prec_strength: Double?
    var is_thunder: Bool?
    var wind_dir: String?
    var wind_speed: Double?
    var wind_gust: Double?
    var pressure_mm: Int?
    var pressure_pa: Int?
    var humidity: Int?
    var uv_index: Int?
    var soil_temp: Int?
    var soil_moisture: Double?
    var prec_mm: Double?
    var prec_period: Int?
    var prec_prob: Double?
}

struct BiometYandex: Codable {
    var index: Int?
    var condition: String?
}
