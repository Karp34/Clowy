//
//  SelectColor.swift
//  Clowy
//
//  Created by Егор Карпухин on 24.11.2024.
//
import SwiftUI

struct SelectColor: View {
    @EnvironmentObject var viewModel: CreateClothViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    let colors: [[String]] = [
        ["#FFFFFF"],
        ["#323232", "#808080", "#CCCCCC"],
        ["#806030", "#CC9A4D", "#E0C49A"],
        ["#A60000", "#D90000", "#FF7777"],
        ["#D97500", "#FDBF1F", "#FFBE5B"],
        ["#E5CF00", "#FFE600", "#FFF27A"],
        ["#137016", "#1BA320", "#55DA5A"],
        ["#0070C0", "#00B0F0", "#8AE0FF"],
        ["#380094", "#8236FF", "#B283FF"],
        ["#EF32FF", "#F68EFF", "#FAC2FF"]
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(colors, id: \.self) { colorList in
                    Button {
                        withAnimation { viewModel.color = colorList.first! }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16).foregroundStyle(.white)
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.primaryBlueBrand.opacity(colorList.contains(viewModel.color) ? 1 : 0), lineWidth: 2)
                            if let image = viewModel.chosenDefaultImage {
                                VStack(spacing: 10) {
                                    image
                                        .resizable()
                                        .colorMultiply(colorList.contains(viewModel.color) ? Color(hex: viewModel.color) : Color(hex: colorList.first!))
                                        .scaledToFit()
                                        .padding(.top, 24)
                                        .padding(.horizontal, 20)
                                    ChosenColorView(colorList: colorList)
                                }
                                .padding(.bottom, 20)
                            }
                        }
                        .padding(2)
                        .aspectRatio(0.8, contentMode: .fit)
                        .shadow(color: Color.shadowGrey.opacity(0.05), radius: 8, y: 4)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            Spacer().frame(height: 40)
        }
    }
}
