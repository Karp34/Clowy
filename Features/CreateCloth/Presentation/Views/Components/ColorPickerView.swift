//
//  ChooseColorView.swift
//  MyCombineProject
//
//  Created by Егор Карпухин on 19.01.2022.
//

import SwiftUI

struct ColorPickerView: View {
    @EnvironmentObject var viewModel: CreateClothViewModel
    let insets = EdgeInsets(top: 8, leading: 24, bottom: 2, trailing: 24)

    let colorList: [[String]] = [
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
        VStack(alignment: .leading, spacing: 0) {
            Text("Color")
                .font(.custom("Montserrat-SemiBold", size: 16))
                .foregroundColor(Color.primaryGrey)
                .padding(.horizontal, 24)
                .padding(.top, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(colorList, id: \.self) { colors in
                        if colors.contains(viewModel.color) {
                            ChosenColorView(colorList: colors)
                        } else if colors.first == "#FFFFFF" {
                            Circle()
                                .stroke(Color.gray, style: StrokeStyle(lineWidth: 1))
                                .foregroundColor(Color(hex: colors.first!))
                                .frame(width: 32, height: 32)
                                .onTapGesture {
                                    withAnimation { viewModel.color = colors.first! }
                                }
                        } else {
                            Circle()
                                .frame(width: 32, height: 32)
                                .foregroundColor(Color(hex: colors.first!))
                                .onTapGesture {
                                    withAnimation { viewModel.color = colors.first! }
                                }
                        }
                    }
                }
                .frame(height: 40)
                .padding(insets)
            }
        }
    }
}
