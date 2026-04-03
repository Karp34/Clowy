//
//  ClothImage.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 15.10.2022.
//

import SwiftUI
import Kingfisher

struct ClothImage: View {
    let imageName: String
    let isDefault: Bool
    let color: String
    let rawImage: UIImage?
    let imageURL: URL?
    let onAppear: () async -> Void

    var body: some View {
        if let rawImage {
            Image(uiImage: rawImage)
                .resizable()
        } else if isDefault {
            Image(imageName)
                .resizable()
                .colorMultiply(Color(hex: color))
        } else {
            KFImage.url(imageURL)
                .resizable()
                .placeholder { ClothImagePlaceholder() }
                .task { await onAppear() }
        }
    }
}

