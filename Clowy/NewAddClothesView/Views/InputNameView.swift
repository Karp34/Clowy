//
//  InputNameView.swift
//  MyCombineProject
//
//  Created by Егор Карпухин on 19.01.2022.
//

import SwiftUI

struct InputNameView: View {
    @State var newClothesName: String = ""
    var hint = "Input clothes name"
    @State var name = ""
    
    @ObservedObject var viewModel = AddClothesViewModel.shared
    
    var body: some View {
        VStack (alignment: .leading) {
            
            HStack (alignment: .top) {
                ZStack(alignment: .leading) {
                    TextField(hint, text: $viewModel.cloth.name)
                        .textFieldStyle(CustomFieldStyle())
                }
                Spacer()
                if viewModel.cloth.name.count > 2 {
                    ZStack{
                        Circle()
                            .frame(width: 18, height: 18)
                            .foregroundColor(Color(hex: "#79D858"))
                        Image("Ok")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                            .foregroundColor(Color(hex: "##FFFFFF"))
                    }
                }
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(hex: "#DADADA"))
        }
    }
}
