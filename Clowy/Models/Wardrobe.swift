//
//  Wardrobe.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 15.10.2022.
//

import SwiftUI

struct Wardrobe: Identifiable, Equatable {
    var id: WardrobeOrder
    var clothesTypeName: ClothesType
    var items: [Cloth]
    var ratio: AspectRatioTypes
}

enum WardrobeOrder: Int, CaseIterable, Codable {
    case headdresses = 0
    case sunglasses = 1
    case scarves = 2
    case jackets = 3
    case suitJackets = 4
    case hoodies = 5
    case shirts = 6
    case thermals = 7
    case tshirts = 8
    case dresses = 9
    case skirts = 10
    case pants = 11
    case thermalPants = 12
    case socks = 13
    case sneakers = 14
    case umbrellas = 15
    case gloves = 16
    case accessories = 17
}

struct AspectRatioType {
    var ratio: AspectRatioTypes
}

enum AspectRatioTypes: Double {
    case square = 0.95
    case rectangle = 0.8
}
