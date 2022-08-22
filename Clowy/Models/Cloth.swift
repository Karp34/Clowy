//
//  Cloth.swift
//  Clowy2
//
//  Created by Егор Карпухин on 23.04.2022.
//

import SwiftUI

struct Cloth: Identifiable, Equatable {
    var id: Int
    var name: String
    var clothesType: ClothesType
    var temp: String = "none"
    var color: String = "none"
    var image: String = "none"
}


enum ClothesType: String, CaseIterable, Codable {
    case headdresses = "Headdresses"
    case sunglasses = "Sunglasses"
    case scarves = "Scarves"
    case jackets = "Jackets"
    case hoodies = "Sweaters"
    case thermals = "Thermals"
    case tshirts = "T-Shirts"
    case pants = "Pants"
    case thermalPants = "Thermal pants"
    case socks = "Socks"
    case sneakers = "Sneakers"
    case umbrellas = "Umbrellas"
    case gloves = "Gloves"
    case accessories = "Accessories"
    case blank = ""
}
