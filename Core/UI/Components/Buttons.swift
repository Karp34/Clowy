//
//  Buttons.swift
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
    let color: Color
    let radius: CGFloat
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .background (
            RoundedRectangle(cornerRadius: radius)
                .frame(height: 56)
                .foregroundColor(isEnabled ? color : Color.separatorGrey )
                .brightness(configuration.isPressed ? -0.2 : 0)
            )
        }
}

struct DefaultCircleColorButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled: Bool
    let color: Color
    let size: CGFloat
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .background (
            Circle()
                .frame(width: size, height: size)
                .foregroundColor(isEnabled ? color : Color.separatorGrey )
                .brightness(configuration.isPressed ? -0.2 : 0)
            )
        }
}

struct NoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}
