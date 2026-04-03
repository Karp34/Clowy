//
//  Wardrobe.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Foundation

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

enum AspectRatioTypes: Double {
    case square = 0.95
    case rectangle = 0.8
}
