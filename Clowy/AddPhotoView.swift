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
    
    @ObservedObject var viewModel: AddClothesViewModel
    @State var show = false
    
    var body: some View {
        if self.viewModel.image.count != 0 {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "#DADADA"), style: StrokeStyle(lineWidth: 1, dash: [4]))
                VStack {
                    ClothImage(imageName: viewModel.image, isDeafult: viewModel.isDefault, color: viewModel.chosenColor)
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
                        viewModel.image.count = 0
                        viewModel.isDefault = false
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
                ImagePicker(show: self.$show, image: $viewModel.image)
                    .environment(\.managedObjectContext, self.moc)
            }
        }
    }
}
