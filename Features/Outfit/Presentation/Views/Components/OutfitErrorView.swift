//
//  OutfitErrorView.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI

struct OutfitErrorView: View {
    var onRetry: () -> Void

    var body: some View {
        VStack {
            Spacer()
            WarningView(
                image: Image(systemName: "exclamationmark.circle.fill"),
                title: "Failed to load outfits"
            )
            Spacer()
            Button(action: onRetry) {
                ZStack {
                    Rectangle().foregroundColor(.clear).frame(height: 56)
                    Text("Try again")
                        .font(.custom("Montserrat-Bold", size: 16))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(DefaultColorButtonStyle(color: Color.primaryBlueBrand, radius: 24))
            .padding(.horizontal, 24)
        }
    }
}
