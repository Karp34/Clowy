//
//  ColorImagesView.swift
//  Clowy
//
//  Created by Егор Карпухин on 07.10.2022.
//

import SwiftUI

struct ColorImagesView: View {
    let imagePaint = ImagePaint(image: Image("Shapka"))
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            VStack {
                Text("multi")
                HStack {
                    Image("Shapka")
                        .frame(width: 96, height: 96)
                        .colorMultiply(Color(hex: "#795FC2"))
                    Image("Shapka")
                        .frame(width: 96, height: 96)
                        .colorMultiply(Color(hex: "#00A688"))
                }
            }
        }
    }
}
