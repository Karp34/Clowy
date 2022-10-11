//
//  ColorImagesView.swift
//  Clowy
//
//  Created by Егор Карпухин on 07.10.2022.
//

import SwiftUI

struct ColorImagesView: View {
    @StateObject private var viewModel = AddClothesViewModel.shared
    let colorList: [String] = ["#A5D469", "#C6FF7E", "#7DA150"]
    
    var body: some View {
        if viewModel.image != nil {
            VStack {
                Image(uiImage: UIImage(data: self.viewModel.image)!)
                    .resizable()
                    .scaledToFit()
                    .colorMultiply(Color(hex: viewModel.chosenColor))
            }
        }
    }
}
