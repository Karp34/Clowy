//
//  ChooseFlowView.swift
//  Clowy
//
//  Created by Егор Карпухин on 01.11.2024.
//

import SwiftUI

struct ChooseFlowView: View {
    @StateObject private var viewModel = CreateNewClothViewModel.shared
    
    var body: some View {
        VStack {
            ImagePickerV2 { image in
                viewModel.cloth.rawImage = image
            }
            .frame(height: 130)
            .shadow(color:Color(hex: "#747A800D").opacity(0.05), radius: 8, y: 4)
            
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.white)
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex:"F1F1F1"), lineWidth: 1)
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .frame(width: 46, height: 46)
                            .foregroundColor(Color.primaryBlueBrand)
                            .opacity(0.1)
                        Image(systemName: "tshirt")
                            .foregroundColor(Color.primaryBlueBrand)
                    }
                    Text("Use basic photo")
                        .font(.custom("Montserrat-Regular", size: 12))
                        .foregroundColor(Color.primaryBlueBrand)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
            }
            .frame(height: 130)
            .shadow(color:Color(hex: "#747A800D").opacity(0.05), radius: 8, y: 4)
            .onTapGesture {
                withAnimation {
                    viewModel.currentPage = 2
                }
                //reset viewModel if user changed flow
                if viewModel.isDefaultPhoto {
                    viewModel.reset()
                    viewModel.isDefaultPhoto = false
                }
            }
        }
    }
}
