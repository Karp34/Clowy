//
//  SwiftUIView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 19.04.2022.
//

import SwiftUI

struct Wardrobe: Identifiable {
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
    case hoodies = 4
    case thermals = 5
    case tshirts = 6
    case pants = 7
    case thermalPants = 8
    case socks = 9
    case sneakers = 10
    case umbrellas = 11
    case gloves = 12
    case accessories = 13
}

struct AspectRatioType {
    var ratio: AspectRatioTypes
}

enum AspectRatioTypes: Double {
    case square = 0.95
    case rectangle = 0.75
}
