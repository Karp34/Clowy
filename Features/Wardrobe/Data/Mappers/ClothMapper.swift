//
//  ClothMapper.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import SwiftUI

enum ClothMapper {
    static func toDomain(_ dto: ClothDTO) -> Cloth {
        Cloth(
            id: dto.id,
            name: dto.name,
            type: ClothesType(rawValue: dto.type) ?? .blank,
            color: dto.color,
            temperature: dto.temperature.compactMap { TemperatureType(rawValue: $0) },
            isDefault: dto.isDefault,
            image: dto.image,
            creationDate: dto.creationDate
        )
    }
}
