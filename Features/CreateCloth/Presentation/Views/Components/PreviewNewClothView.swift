//
//  PreviewNewClothVeiw.swift
//  Clowy
//
//  Created by Егор Карпухин on 05.11.2024.
//

import SwiftUI

struct PreviewNewClothView: View {
    @EnvironmentObject var viewModel: CreateClothViewModel
    @State var input = ""
    @FocusState private var isTextFieldFocused: Bool
    @State var isChangingName = false

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 14) {
                if !viewModel.isDefault {
                    if let rawImage = viewModel.rawImage {
                        Image(uiImage: rawImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 66)
                    }
                } else {
                    Image(viewModel.image)
                        .resizable()
                        .colorMultiply(viewModel.color.isEmpty ? Color.white : Color(hex: viewModel.color))
                        .aspectRatio(contentMode: .fit)
                        .padding(.horizontal, 66)
                }

                if isChangingName {
                    TextField("", text: $input)
                        .onSubmit {
                            withAnimation {
                                viewModel.name = input
                                isChangingName = false
                            }
                        }
                        .onChange(of: input) {
                            withAnimation { viewModel.name = input }
                        }
                        .onChange(of: viewModel.currentPage) {
                            isTextFieldFocused = false
                        }
                        .textFieldStyle(CustomFieldStyle3Medium(size: 14))
                        .multilineTextAlignment(.center)
                        .focused($isTextFieldFocused)
                        .frame(height: 16)
                        .lineLimit(1)
                        .padding(.horizontal, 60)
                } else {
                    HStack(spacing: 4) {
                        Spacer()
                        Text(viewModel.name.isEmpty ? "NO INFO" : viewModel.name)
                            .font(.custom("Montserrat-Medium", size: 14))
                            .foregroundStyle(Color.primaryGrey)
                        Image("Edit")
                            .resizable()
                            .foregroundColor(Color.primaryGrey)
                            .frame(width: 16, height: 16)
                            .scaledToFit()
                            .opacity(isTextFieldFocused ? 0 : 1)
                        Spacer()
                    }
                    .frame(height: 16)
                    .onTapGesture {
                        withAnimation {
                            isChangingName = true
                            isTextFieldFocused = true
                            viewModel.userChangedName = true
                        }
                    }
                }
            }
            .padding(.bottom, 40)
            .padding(.top, 22)
            .frame(maxWidth: .infinity, minHeight: 230)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 44)
            .onChange(of: viewModel.type) {
                if viewModel.type != .blank && !viewModel.userChangedName {
                    viewModel.name = viewModel.createClothName()
                    input = viewModel.name
                    isTextFieldFocused = false
                }
            }
            .onChange(of: viewModel.temperatureSelection) {
                if viewModel.type != .blank && !viewModel.userChangedName {
                    viewModel.name = viewModel.createClothName()
                    input = viewModel.name
                    isTextFieldFocused = false
                }
            }

            // Category
            VStack(alignment: .leading, spacing: 12) {
                Text("Category")
                    .font(.custom("Montserrat-Medium", size: 14))
                    .foregroundStyle(Color.primaryGrey)
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundStyle(Color.inputBackground)
                        .frame(height: 46)
                    Text(viewModel.type.rawValue)
                        .font(.custom("Montserrat-Medium", size: 15))
                        .foregroundStyle(Color.primaryGrey.opacity(0.7))
                        .padding(.horizontal, 16)
                }
            }

            // Temperature
            VStack(alignment: .leading, spacing: 12) {
                Text("Temperature")
                    .font(.custom("Montserrat-Medium", size: 14))
                    .foregroundStyle(Color.primaryGrey)
                HStack(spacing: 8) {
                    temperatureBox(label: "Min", value: viewModel.temperatureSelection.lowerBound)
                    temperatureBox(label: "Max", value: viewModel.temperatureSelection.upperBound)
                }
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
                    .foregroundStyle(Color.primaryGrey.opacity(0.7))
                Spacer()
                Text(value >= 1 ? "+\(Int(value))" : "\(Int(value))")
                    .font(.custom("Montserrat-Medium", size: 15))
                    .foregroundStyle(Color.primaryGrey.opacity(0.7))
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 46)
    }
}
