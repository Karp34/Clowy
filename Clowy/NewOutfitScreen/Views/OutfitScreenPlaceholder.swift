//
//  OutfitScreenPlaceholder.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 10.11.2022.
//

import SwiftUI
import WaterfallGrid

struct OutfitScreenPlaceholder: View {
    var body: some View {
        Spacer(minLength: 24)
        VStack(alignment: .leading, spacing: 16) {
            ForEach(0..<5, id:\.self) { number in
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 193, height: 26)
                    .foregroundColor(Color(hex: "#EEEFF1"))
                WaterfallGrid(0..<4, id:\.self) { item in
                    MiniCardPlaceholder()
                }
                .gridStyle(columns: 4, spacing: 16)
                .padding(.bottom, 16)
            }
        }
        .padding(.horizontal, 24)
    }
}

struct MiniCardPlaceholder: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
//                .frame(width: 72, height: 72)
                .aspectRatio(1/1, contentMode: .fill)
            Circle()
                .padding(16)
                .foregroundColor(Color(hex: "#EEEFF1"))
        }
    }
}
