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
    case dresses = 7
    case skirts = 8
    case pants = 9
    case thermalPants = 10
    case socks = 11
    case sneakers = 12
    case umbrellas = 13
    case gloves = 14
    case accessories = 15
}

struct AspectRatioType {
    var ratio: AspectRatioTypes
}

enum AspectRatioTypes: Double {
    case square = 0.95
    case rectangle = 0.75
}
