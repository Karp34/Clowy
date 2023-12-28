//
//  Wardrobe.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 02.10.2022.
//

import SwiftUI

struct Cloth: Identifiable, Equatable, Hashable {
    var id: String
    var name: String
    var type: ClothesType
    var color: String
    var temperature: [String]
    var isDefault: Bool
    var image: String
    var rawImage: UIImage?
}

enum ClothesType: String, CaseIterable, Codable {
    case headdresses = "Headdresses"
    case sunglasses = "Sunglasses"
    case scarves = "Scarves"
    case jackets = "Jackets"
    case suit_jackets = "Suit Jackets"
    case hoodies = "Sweaters"
    case thermals = "Thermals"
    case shirts = "Shirts"
    case tshirts = "T-Shirts"
    case dresses = "Dresses"
    case skirts = "Skirts"
    case pants = "Pants"
    case thermalPants = "Thermal Pants"
    case socks = "Socks"
    case sneakers = "Shoes"
    case umbrellas = "Umbrellas"
    case gloves = "Gloves"
    case accessories = "Accessories"
    case blank = ""
}
