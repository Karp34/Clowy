//
//  ChooseTemperatureRangeView.swift
//  Clowy
//
//  Created by Егор Карпухин on 02.11.2024.
//
import SwiftUI

struct ChooseTemperatureRangeView: View {
    @EnvironmentObject var viewModel: CreateClothViewModel

    var body: some View {
        VStack(spacing: 28) {
            RangeSliderView(
                selection: $viewModel.temperatureSelection,
                range: -40...40,
                minimumDistance: 5
            )
            HStack(spacing: 8) {
                temperatureBox(label: "Min", value: viewModel.temperatureSelection.lowerBound)
                temperatureBox(label: "Max", value: viewModel.temperatureSelection.upperBound)
            }
            Spacer()
        }
    }

    private func temperatureBox(label: String, value: CGFloat) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6).foregroundStyle(Color.inputBackground)
            HStack {
                Text(label)
                    .font(.custom("Montserrat-Medium", size: 15))
                    .foregroundStyle(Color.primaryGrey)
                Spacer()
                Text(value >= 1 ? "+\(Int(value))" : "\(Int(value))")
                    .font(.custom("Montserrat-Medium", size: 15))
                    .foregroundStyle(Color.primaryGrey)
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 46)
    }
}
