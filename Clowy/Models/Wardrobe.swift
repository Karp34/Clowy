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

extension Wardrobe {
    mutating func deleteCloth(_ cloth: Cloth) {
        self.items.removeAll { $0.id == cloth.id }
    }
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
    case shorts = 12
    case thermalPants = 13
    case socks = 14
    case sneakers = 15
    case umbrellas = 16
    case gloves = 17
    case accessories = 18
}

struct AspectRatioType {
    var ratio: AspectRatioTypes
}

enum AspectRatioTypes: Double {
    case square = 0.95
    case rectangle = 0.8
}
