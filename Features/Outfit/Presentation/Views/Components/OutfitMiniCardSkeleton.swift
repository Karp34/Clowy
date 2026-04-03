//
//  OutfitMiniCardSkeleton.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI

struct OutfitMiniCardSkeleton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .aspectRatio(1/1, contentMode: .fill)
            Circle()
                .padding(16)
                .foregroundColor(Color.secondaryGrey)
        }
    }
}
