//
//  Outfit.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 02.10.2022.
//

import SwiftUI

struct Outfit: Identifiable {
    var id: String
    var name: String
    var isGenerated: Bool
    var clothes: [String]
    var createDTM : Double?
}
