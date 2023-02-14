//
//  NewWardrobeScreenPlaceholder.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.02.2023.
//

import SwiftUI

struct NewWardrobeScreenPlaceholder: View {
    var body: some View {
        ForEach (0..<6) { id in
            ClothesCollectionPlaceholder()
        }
    }
}
