//
//  ImageView.swift
//  Clowy
//
//  Created by Егор Карпухин on 04.07.2022.
//

import SwiftUI

struct AddPhotoView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel = AddClothesViewModel.shared
    @State var show = false
    @State var isCutOut = false
    
    var body: some View {
        if #available(iOS 16.0, *) {
            if self.viewModel.cloth.image != "" || self.viewModel.cloth.rawImage != nil {
                HStack (spacing: 16) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "#DADADA"), style: StrokeStyle(lineWidth: 1, dash: [4]))
                        VStack {
                            if isCutOut {
                                if let rawImage = viewModel.cloth.rawImage {
                                    ImageLift(imageName: rawImage)
                                        .scaledToFit()
                                        .interactiveDismissDisabled(false)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                            } else {
                                ClothImage(imageName: viewModel.cloth.image, isDeafult: viewModel.cloth.isDefault, color: viewModel.cloth.color, rawImage: viewModel.cloth.rawImage)
                                    .scaledToFit()
                                    .frame(width: 120, height: 120)
                            }
                            
                        }
                        .frame(minHeight: 136)
                        
                        HStack (alignment: .top) {
                            Spacer()
                            VStack {
                                Image(systemName: "trash")
                                    .foregroundColor(Color(hex: "#D85858"))
                                    .frame(width: 20, height: 20)
                                    .padding(16)
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
                                isCutOut = false
                            }
                        }
                    }
                    if !viewModel.cloth.isDefault {
                        DragAndDrop() { image in
                            viewModel.cloth.rawImage = image
                            print(image)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
            } else {
                HStack (spacing: 16) {
                    ImagePickerV2() { image in
                        viewModel.cloth.rawImage = image
                        isCutOut = true
                    }
                    
                    UseStockPhoto()
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
