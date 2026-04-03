//
//  ClothImagePlaceholder.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//
import SwiftUI

struct ClothImagePlaceholder: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color.primaryBlueBrand)
                .opacity(0.2)
                .frame(width: 56, height: 56)
            Image("Veshalka")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 19)
                .foregroundColor(Color.primaryBlueBrand)
        }
    }
}
