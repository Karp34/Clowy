//
//  WardrobeClothesCardCollection.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import SwiftUI
import WaterfallGrid

struct WardrobeClothesCardCollection: View {
    var outfit: [Cloth]
    var textError: String?
    var errorCode: Int?
    var notRealClothesTemps: [NotRealCloth]?
    var color: Color?

    var body: some View {
        ZStack {
            if !outfit.isEmpty {
                WaterfallGrid(outfit) { item in
                    WardrobeClothesCard(
                        cloth: item,
                        notRealClothesTemps: notRealClothesTemps,
                        color: color
                    )
                    .aspectRatio(GetRatio.getRatio(type: item.type).rawValue, contentMode: .fit)
                }
                .padding(.horizontal, 4)
            } else {
                WardrobeEmptyView(textError: textError, errorCode: errorCode, accentColor: color ?? Color.primaryBlueBrand)
                    .padding(.horizontal, 8)
            }
        }
    }
}
