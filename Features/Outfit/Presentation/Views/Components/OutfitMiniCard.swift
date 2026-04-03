//
//  OutfitMiniCard.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI

struct OutfitMiniCard: View {
    var cloth: Cloth

    private let defaultImages = ["DefaultUpperWear", "DefaultPants", "DefaultSneaker"]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .aspectRatio(1/1, contentMode: .fill)
            if defaultImages.contains(cloth.image) {
                Image(cloth.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color.primaryBlueBrand)
            } else {
                ClothImage(
                    imageName: cloth.image,
                    isDefault: cloth.isDefault,
                    color: cloth.color,
                    rawImage: nil,
                    imageURL: nil,
                    onAppear: {}
                )
                .scaledToFit()
                .padding(8)
            }
        }
        .frame(maxWidth: 80, maxHeight: 80)
        .shadow(color: Color.shadowGrey.opacity(0.1), radius: 30, y: 4)
    }
}
