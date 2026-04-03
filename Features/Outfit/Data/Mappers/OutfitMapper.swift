//
//  OutfitMapper.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import Foundation

enum OutfitMapper {
    static func toDomain(_ dto: OutfitDTO) -> Outfit {
        Outfit(
            id: dto.id,
            name: dto.name,
            isGenerated: dto.isGenerated,
            clothes: dto.clothes,
            createDTM: dto.createDTM
        )
    }
}
