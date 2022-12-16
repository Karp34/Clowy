//
//  Buttons.swift
//  Clowy
//
//  Created by Егор Карпухин on 12.10.2022.
//

import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.linear(duration: 0.1), value: configuration.isPressed)
    }
}

struct DefaultColorButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    let color: String
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .background(
            RoundedRectangle(cornerRadius: 24)
                .frame(height: 56)
                .foregroundColor(isEnabled ? Color(hex: color) : Color(hex: "#CBCED2") )
                .brightness(configuration.isPressed ? -0.2 : 0)
            )
        }
}

struct NoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .animation(nil)
    }
}
