//
//  View+Extensions.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import SwiftUI

extension View {
    @ViewBuilder
    func optionalViewModifier<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }

    func placeholder(
        _ text: String,
        when shouldShow: Bool,
        alignment: Alignment = .leading) -> some View {
            
            placeholder(when: shouldShow, alignment: alignment) {
                Text(text)
                    .font(.custom("Montserrat-Regular", size: 16))
                    .foregroundColor(Color.primaryGrey)
            }
    }

    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    func readingScrollView(from coordinateSpace: String, into binding: Binding<CGPoint>) -> some View {
        modifier(ScrollViewOffsetModifier(coordinateSpace: coordinateSpace, offset: binding))
    }
}
