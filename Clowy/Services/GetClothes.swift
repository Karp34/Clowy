//
//  OrderTypes.swift
//  Clowy
//
//  Created by Егор Карпухин on 24.12.2021.


import Foundation

//case headdresses = 0
//case sunglasses = 1
//case scarves = 2
//case jackets = 3
//case hoodies = 4
//case thermals = 5
//case tshirts = 6
//case pants = 7
//case thermalPants = 8
//case socks = 9
//case sneakers = 10
//case umbrellas = 11
//case gloves = 12
//case accessories = 13

class GetClothes {
    static func getClothes() -> [Wardrobe] {
        return [
            //"Headdresses", "Sunglasses", "Scarves", "Jackets", "Sweaters", "Thermals", "T-Shirts", "Dresses", "Skirts", "Pants", "Thermal Pants", "Socks", "Sneakers", "Umbrellas", "Gloves", "Accessories"]
            Wardrobe(id: .headdresses, clothesTypeName: .headdresses, items: [Cloth(id: 0, name: "Black Hat", clothesType: .headdresses, image: "Cloth0"), Cloth(id: 107, name: "Black Hat", clothesType: .headdresses, image: "Cloth0"), Cloth(id: 108, name: "Black Hat", clothesType: .headdresses, image: "Cloth0")], ratio: .square),
            Wardrobe(id: .sunglasses, clothesTypeName: .sunglasses, items: [], ratio: .rectangle),
            Wardrobe(id: .scarves, clothesTypeName: .scarves, items: [], ratio: .rectangle),
            Wardrobe(id: .jackets, clothesTypeName: .jackets, items: [Cloth(id: 1, name: "Black Coat", clothesType: .jackets, image: "Cloth1")], ratio: .rectangle),
            Wardrobe(id: .hoodies, clothesTypeName: ClothesType.hoodies, items: [Cloth(id: 2, name: "Gray Hoodie", clothesType: .hoodies, image: "Cloth2")], ratio: .rectangle),
            Wardrobe(id: .thermals, clothesTypeName: .thermals, items: [], ratio: .rectangle),
            Wardrobe(id: .tshirts, clothesTypeName: .tshirts, items: [Cloth(id: 3, name: "Black Tee", clothesType: .tshirts, image: "Cloth3"), Cloth(id: 7, name: "White Tee", clothesType: .tshirts, image: "Cloth7")], ratio: .rectangle),
            Wardrobe(id: .dresses, clothesTypeName: .dresses, items: [], ratio: .square),
            Wardrobe(id: .skirts, clothesTypeName: .skirts, items: [], ratio: .square),
            Wardrobe(id: .pants, clothesTypeName: .pants, items: [Cloth(id: 4, name: "Black Pants", clothesType: .pants, image: "Cloth4"), Cloth(id: 8, name: "Jeens Shorts", clothesType: .pants, image: "Cloth8")], ratio: .rectangle),
            Wardrobe(id: .thermalPants, clothesTypeName: .thermalPants, items: [], ratio: .rectangle),
            Wardrobe(id: .socks, clothesTypeName: .socks, items: [Cloth(id: 5, name: "High White Socks", clothesType: .socks, image: "Cloth5")], ratio: .square),
            Wardrobe(id: .sneakers, clothesTypeName: .sneakers, items: [Cloth(id: 6, name: "Dunk High", clothesType: .sneakers, image: "Cloth6"), Cloth(id: 10, name: "White Air Force 1", clothesType: .sneakers, image: "Cloth10")], ratio: .square),
            Wardrobe(id: .umbrellas, clothesTypeName: .umbrellas, items: [], ratio: .square),
            Wardrobe(id: .gloves, clothesTypeName: .gloves, items: [], ratio: .rectangle),
            Wardrobe(id: .accessories, clothesTypeName: .accessories, items: [Cloth(id: 11, name: "Sunglasses", clothesType: .accessories, image: "Cloth11")], ratio: .square)
            ]
    }
}

