//
//  RemoveBackgroundView.swift
//  Clowy
//
//  Created by Егор Карпухин on 01.11.2024.
//

import SwiftUI

struct RemoveBackgroundView: View {
    @StateObject private var viewModel = CreateNewClothViewModel.shared
    
    var body: some View {
        
        VStack(spacing: 8){
            
            if self.viewModel.cloth.image != "" || self.viewModel.cloth.rawImage != nil {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(Color(hex:"#F3F3FF"))
                    
                    if let rawImage = viewModel.cloth.rawImage {
                        ImageLift(imageName: rawImage)
                            .scaledToFit()
                            .frame(height: 232)
                            .interactiveDismissDisabled(false)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    HStack (alignment: .top) {
                        Spacer()
                        VStack {
                            Image(systemName: "trash")
                                .foregroundColor(Color(hex: "#D85858"))
                                .frame(width: 20, height: 20)
                                .padding(16)
                                .opacity((viewModel.cloth.rawImage != nil) ? 1 : 0)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                    }
                    .onTapGesture {
                        withAnimation {
                            viewModel.cloth.rawImage = nil
                            viewModel.cloth.isDefault = false
                            viewModel.imageId = viewModel.cloth.image
                            viewModel.cloth.image = ""
                            viewModel.cloth.rawImage = nil
                            viewModel.DnDpreviewImage = nil
                        }
                    }
                }
                .frame(height: 248)
            } else {
                ImagePickerV2 { image in
                    viewModel.cloth.rawImage = image
                }
                .frame(height: 248)
            }
            
            DragAndDrop() { image in
                viewModel.cloth.rawImage = image
                print(image)
            }
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .frame(height: 248)
        }
    }
}
