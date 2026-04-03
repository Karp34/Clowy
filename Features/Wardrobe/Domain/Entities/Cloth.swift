//
//  Cloth.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Foundation

struct Cloth: Identifiable, Equatable, Hashable {
    var id: String
    var name: String
    var type: ClothesType
    var color: String
    var temperature: [TemperatureType]
    var isDefault: Bool
    var image: String
    var creationDate: Int
}
