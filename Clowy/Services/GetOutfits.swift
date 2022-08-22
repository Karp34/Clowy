//
//  SwiftUIView.swift
//  Clowy
//
//  Created by Егор Карпухин on 25.04.2022.
//

import Foundation

class GetOutfits {
    
    static func getOutfits() -> [Outfit] {
        return [
            Outfit(id: 0, outfit: [
                Cloth(id: 0, name: "Black Hat", clothesType: .headdresses, image: "Cloth0"),
                Cloth(id: 1, name: "Black Coat", clothesType: .jackets, image: "Cloth1"),
                Cloth(id: 2, name: "Gray Hoodie", clothesType: .hoodies, image: "Cloth2"),
                Cloth(id: 3, name: "Black Tee", clothesType: .tshirts, image: "Cloth3"),
                Cloth(id: 4, name: "Black Pants", clothesType: .pants, image: "Cloth4"),
                Cloth(id: 5, name: "High White Socks", clothesType: .socks, image: "Cloth5"),
                Cloth(id: 6, name: "Dunk High", clothesType: .sneakers, image: "Cloth6")
            ], isGenerated: true),
            Outfit(id: 1, outfit: [
                Cloth(id: 7, name: "White Tee", clothesType: .tshirts, image: "Cloth7"),
                Cloth(id: 8, name: "Jeens Shorts", clothesType: .pants, image: "Cloth8"),
                Cloth(id: 10, name: "White Air Force 1", clothesType: .sneakers, image: "Cloth10")
            ], isGenerated: false),
            Outfit(id: 2, outfit: [
                Cloth(id: 0, name: "Black Hat", clothesType: .headdresses, image: "Cloth0"),
                Cloth(id: 1, name: "Black Coat", clothesType: .jackets, image: "Cloth1"),
                Cloth(id: 2, name: "Gray Hoodie", clothesType: .hoodies, image: "Cloth2"),
                Cloth(id: 3, name: "Black Tee", clothesType: .tshirts, image: "Cloth3"),
                Cloth(id: 4, name: "Black Pants", clothesType: .pants, image: "Cloth4"),
                Cloth(id: 5, name: "High White Socks", clothesType: .socks, image: "Cloth5"),
            ], isGenerated: true),
            Outfit(id: 3, outfit: [], isGenerated: false)
        ]
    }
}
