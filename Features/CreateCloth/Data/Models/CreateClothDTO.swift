//
//  CreateClothDTO.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import Foundation

struct CreateClothDTO {
    let id: String
    let name: String
    let type: String
    let image: String
    let temperature: [String]
    let color: String
    let isDefault: Bool
    let creationDate: Int
}
