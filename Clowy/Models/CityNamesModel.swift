//
//  CityNamesModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 02.09.2022.
//

import SwiftUI

struct CityNamesModel: Codable {
    var data: [CityModel]?
    var link: [LinksCityModel]?
    var metadata: MetadataModel?
}

struct LinksCityModel: Codable {
    var rel: String
    var href: String
}

struct MetadataModel: Codable {
    var currentOffset: Double
    var totalCount: Double
}

struct CityModel: Codable {
    var id: Double
    var wikiDataId: String
    var type: String
    var city: String
    var name: String
    var country: String
    var countryCode: String
    var region: String
    var regionCode: String
    var latitude: Double
    var longitude: Double
    var population: Double
}
