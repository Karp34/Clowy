//
//  InputNameView.swift
//  MyCombineProject
//
//  Created by Егор Карпухин on 19.01.2022.
//

import SwiftUI

struct CustomFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.custom("Montserrat-Semibold", size: 16))
            .foregroundColor(Color(hex: "#646C75"))
    }
}

struct CustomFieldStyle2: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.custom("Montserrat-Semibold", size: 32))
            .foregroundColor(Color(hex: "#FFFFFF"))
    }
}

struct InputNameView: View {
    @State var newClothesName: String = ""
    @State var title = "Add item"
    var hint = "Input clothes name"
    @State var name = ""
    
    @ObservedObject var viewModel: AddClothesViewModel
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(title)
                .font(.custom("Montserrat-SemiBold", size: 22))
                .foregroundColor(Color(hex: "#646C75"))
                .padding(.top, 24)
            
            HStack (alignment: .top) {
                ZStack(alignment: .leading) {
                    TextField(hint, text: $viewModel.name)
                        .textFieldStyle(CustomFieldStyle())
                }
                Spacer()
                if viewModel.name.count > 2 {
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

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
