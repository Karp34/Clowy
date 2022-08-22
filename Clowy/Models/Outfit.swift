//
//  Outfit.swift
//  Clowy
//
//  Created by Егор Карпухин on 27.04.2022.
//

import SwiftUI

struct Outfit: Identifiable {
    var id: Int
    var outfit: [Cloth]
    var isGenerated: Bool
}
