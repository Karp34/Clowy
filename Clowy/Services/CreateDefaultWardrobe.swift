//
//  CreateDefaultWardrobe.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.02.2023.
//

class CreateDefaultWardrobe {
    static func getClothes() -> [Wardrobe] {
        return [
            Wardrobe(id: .headdresses, clothesTypeName: .headdresses, items: [], ratio: .square),
            Wardrobe(id: .sunglasses, clothesTypeName: .sunglasses, items: [], ratio: .rectangle),
            Wardrobe(id: .scarves, clothesTypeName: .scarves, items: [], ratio: .rectangle),
            Wardrobe(id: .jackets, clothesTypeName: .jackets, items: [], ratio: .rectangle),
            Wardrobe(id: .suitJackets, clothesTypeName: .suitJackets, items: [], ratio: .rectangle),
            Wardrobe(id: .hoodies, clothesTypeName: .hoodies, items: [], ratio: .rectangle),
            Wardrobe(id: .shirts, clothesTypeName: .shirts, items: [], ratio: .rectangle),
            Wardrobe(id: .thermals, clothesTypeName: .thermals, items: [], ratio: .rectangle),
            Wardrobe(id: .tshirts, clothesTypeName: .tshirts, items: [], ratio: .rectangle),
            Wardrobe(id: .dresses, clothesTypeName: .dresses, items: [], ratio: .square),
            Wardrobe(id: .skirts, clothesTypeName: .skirts, items: [], ratio: .square),
            Wardrobe(id: .pants, clothesTypeName: .pants, items: [], ratio: .rectangle),
            Wardrobe(id: .thermalPants, clothesTypeName: .thermalPants, items: [], ratio: .rectangle),
            Wardrobe(id: .socks, clothesTypeName: .socks, items: [], ratio: .square),
            Wardrobe(id: .sneakers, clothesTypeName: .sneakers, items: [], ratio: .square),
            Wardrobe(id: .umbrellas, clothesTypeName: .umbrellas, items: [], ratio: .square),
            Wardrobe(id: .gloves, clothesTypeName: .gloves, items: [], ratio: .rectangle),
            Wardrobe(id: .accessories, clothesTypeName: .accessories, items: [], ratio: .square)
            ]
    }
}

