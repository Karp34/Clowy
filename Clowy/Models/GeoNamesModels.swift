//
//  GeoNamesModels.swift
//  Clowy
//
//  Created by Egor Karpukhin on 06/01/2024.
//

import SwiftUI

struct Geoname: Codable {
    let adminCode1: String?
    let lng: String?
    let geonameId: Int?
    let toponymName: String?
    let countryId: String?
    let fcl: String?
    let population: Int?
    let countryCode: String
    let name: String
    let fclName: String?
    let adminCodes1: AdminCodes1?
    let countryName: String
    let fcodeName: String?
    let adminName1: String?
    let lat: String?
    let fcode: String?
}

struct AdminCodes1: Codable {
    let ISO3166_2: String
}

struct GeonamesResponse: Codable {
    let totalResultsCount: Int
    let geonames: [Geoname]
}
