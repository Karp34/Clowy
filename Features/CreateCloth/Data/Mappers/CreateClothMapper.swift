//
//  CreateClothMapper.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Foundation

enum CreateClothMapper {
    static func toDTO(_ input: CreateClothInput) -> CreateClothDTO {
        CreateClothDTO(
            id: input.id,
            name: input.name,
            type: input.type,
            image: input.image,
            temperature: input.temperature.map { $0.rawValue },
            color: input.color,
            isDefault: input.isDefault,
            creationDate: Int(Date().timeIntervalSince1970)
        )
    }

    static func toFirestore(_ dto: CreateClothDTO) -> [String: Any] {
        [
            "name": dto.name,
            "type": dto.type,
            "image": dto.image,
            "temp": dto.temperature,
            "color": dto.color,
            "isDefault": dto.isDefault,
            "creationDate": dto.creationDate
        ]
    }
}
