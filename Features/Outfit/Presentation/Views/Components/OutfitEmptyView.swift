//
//  OutfitEmptyView.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI

struct OutfitEmptyView: View {
    var onCreateTap: () -> Void

    var body: some View {
        VStack {
            Spacer()
            WarningView(
                image: Image("Liked"),
                title: "No clothing sets",
                subtitle: "Here you can create a set of clothes for any purpose and weather",
                color: "#678CD4"
            )
            Spacer()
            Button(action: onCreateTap) {
                ZStack {
                    Rectangle().foregroundColor(.clear).frame(height: 56)
                    Text("Create outfits")
                        .font(.custom("Montserrat-Bold", size: 16))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(DefaultColorButtonStyle(color: Color.primaryBlueBrand, radius: 24))
            .padding(.horizontal, 24)
        }
    }
}
