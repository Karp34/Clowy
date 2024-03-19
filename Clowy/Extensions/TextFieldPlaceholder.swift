//
//  TextFieldPlaceholder.swift
//  Clowy
//
//  Created by Егор Карпухин on 17.03.2024.
//

import SwiftUI

extension View {
    func placeholder(
        _ text: String,
        when shouldShow: Bool,
        alignment: Alignment = .leading) -> some View {
            
            placeholder(when: shouldShow, alignment: alignment) {
                Text(text)
                    .font(.custom("Montserrat-Regular", size: 16))
                    .foregroundColor(Color(hex: "#909BA8"))
            }
    }
}
