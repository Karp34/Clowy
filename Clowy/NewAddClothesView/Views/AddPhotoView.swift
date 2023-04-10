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
    
    var body: some View {
        if self.viewModel.cloth.image != "" || self.viewModel.cloth.rawImage != nil {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "#DADADA"), style: StrokeStyle(lineWidth: 1, dash: [4]))
                VStack {
                    ClothImage(imageName: viewModel.cloth.image, isDeafult: viewModel.cloth.isDefault, color: viewModel.cloth.color, rawImage: viewModel.cloth.rawImage)
                        .scaledToFit()
                        .frame(width: 96, height: 96)
                }
                HStack (alignment: .top) {
                    Spacer()
                    VStack {
                        Image(systemName: "trash")
                            .foregroundColor(Color(hex: "#646C75"))
                            .padding(16)
                        Spacer()
                    }
                }
                .frame(height: 133)
                .onTapGesture {
                    withAnimation {
                        viewModel.cloth.rawImage = nil
                        viewModel.cloth.isDefault = false
                        viewModel.imageId = viewModel.cloth.image
                        viewModel.cloth.image = ""
                    }
                }
            }
            .frame(height: 133)
        } else {
            HStack (spacing: 16) {
                Button {
                    show.toggle()
                } label: {
                    UsePhotoFromGalary()
                }
                
                UseStockPhoto()
            }
            .sheet(isPresented: self.$show) {
                ImagePicker(show: $show, image: $viewModel.cloth.rawImage)
                    .environment(\.managedObjectContext, self.moc)
            }
        }
    }
}
