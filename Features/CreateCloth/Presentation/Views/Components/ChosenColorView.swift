//
//  ChosenColor.swift
//  Clowy
//
//  Created by Егор Карпухин on 25.11.2024.
//
import SwiftUI

struct ChosenColorView: View {
    var colorList: [String]
    @EnvironmentObject var viewModel: CreateClothViewModel

    var body: some View {
        HStack(spacing: 4) {
            ForEach(colorList, id: \.self) { color in
                ZStack {
                    Circle()
                        .foregroundColor(Color(hex: color))
                        .frame(width: 32, height: 32)
                    Circle()
                        .stroke(color == "#FFFFFF" ? .gray : .white.opacity(0), style: StrokeStyle(lineWidth: 1))
                    if color == viewModel.color {
                        Image("Ok")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(color == "#FFFFFF" ? .black : .white)
                            .frame(width: 20, height: 20)
                    }
                }
                .onTapGesture {
                    withAnimation { viewModel.color = color }
                }
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 40))
        .frame(height: 32)
    }
}
