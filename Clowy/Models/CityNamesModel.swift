//
//  CityNamesModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 02.09.2022.
//

import SwiftUI

//struct CityNamesModel: Codable {
//    var data: [CityModel]?
//    var link: [LinksCityModel]?
//    var metadata: MetadataModel?
//}
//
//struct LinksCityModel: Codable {
//    var rel: String
//    var href: String
//}
//
//struct MetadataModel: Codable {
//    var currentOffset: Double
//    var totalCount: Double
//}
//
//struct CityModel: Codable {
//    var id: Double
//    var wikiDataId: String
//    var type: String
//    var city: String
//    var name: String
//    var country: String
//    var countryCode: String
//    var region: String
//    var regionCode: String
//    var latitude: Double
//    var longitude: Double
//    var population: Double
//}

struct City {
    let name: String
    let countryCode: String
    let stateCode: String
    let latitude: String
    let longitude: String
}

extension City: Decodable {
    enum CodingKeys: String, CodingKey {
        case name
        case countryCode = "countryCode"
        case stateCode = "stateCode"
        case latitude
        case longitude
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        countryCode = try container.decode(String.self, forKey: .countryCode)
        stateCode = try container.decode(String.self, forKey: .stateCode)
        latitude = try container.decode(String.self, forKey: .latitude)
        longitude = try container.decode(String.self, forKey: .longitude)
    }
}
