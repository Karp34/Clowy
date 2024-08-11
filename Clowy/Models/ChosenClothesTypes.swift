//
//  ChosenClothesTypes.swift
//  Clowy
//
//  Created by Егор Карпухин on 24.08.2022.
//

import SwiftUI

class GetChosenClothes {
    static func getChosenClothes() -> [ChosenClothesTypes] {
        return [
//            ChosenClothesTypes(name: "male", clothes: ["Headdresses", "Sunglasses", "Scarves", "Jackets", "Sweaters", "Thermals", "T-Shirts", "Pants", "Thermal Pants", "Socks", "Sneakers", "Umbrellas", "Gloves", "Accessories"]),
            ChosenClothesTypes(name: "all", clothes: ["Headdresses", "Sunglasses", "Scarves", "Jackets", "Sweaters", "Thermals", "T-Shirts", "Dresses", "Skirts", "Pants", "Thermal Pants", "Socks", "Sneakers", "Umbrellas", "Gloves", "Accessories"])
        ]
    }
}

struct ChosenClothesTypes {
    let name: String
    let clothes: [String]
}
