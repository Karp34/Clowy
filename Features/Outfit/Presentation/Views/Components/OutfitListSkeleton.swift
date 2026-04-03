//
//  OutfitListSkeleton.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI
import WaterfallGrid

struct OutfitListSkeleton: View {
    var body: some View {
        Spacer(minLength: 24)
        VStack(alignment: .leading, spacing: 16) {
            ForEach(0..<5, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 193, height: 26)
                    .foregroundColor(Color.secondaryGrey)
                WaterfallGrid(0..<4, id: \.self) { _ in
                    OutfitMiniCardSkeleton()
                }
                .gridStyle(columns: 4, spacing: 16)
                .padding(.bottom, 16)
            }
        }
        .padding(.horizontal, 24)
    }
}
