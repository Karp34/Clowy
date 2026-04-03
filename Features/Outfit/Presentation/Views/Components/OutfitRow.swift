//
//  OutfitRow.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI
import WaterfallGrid

struct OutfitRow: View {
    var outfitName: String
    var clothes: [Cloth]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(outfitName)
                .font(.custom("Montserrat-SemiBold", size: 22))
                .padding(.leading, 24)
                .foregroundColor(Color.primaryGrey)

            WaterfallGrid(clothes) { cloth in
                OutfitMiniCard(cloth: cloth)
            }
            .gridStyle(columns: 4, spacing: 13)
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
        }
    }
}
