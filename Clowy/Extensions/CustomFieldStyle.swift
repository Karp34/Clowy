//
//  CustomFieldStyle.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.02.2023.
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

struct CustomFieldStyle3: TextFieldStyle {
    var size: CGFloat
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.custom("Montserrat-Semibold", size: size))
            .foregroundColor(Color(hex: "#646C75"))
    }
}
