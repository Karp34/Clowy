//
//  ScroolViewModifier.swift
//  Clowy
//
//  Created by Егор Карпухин on 05.07.2022.
//

import SwiftUI

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
    
    typealias Value = CGPoint

}

struct ScrollViewOffsetModifier: ViewModifier {
    let coordinateSpace: String
    @Binding var offset: CGPoint
    
    func body(content: Content) -> some View {
        ZStack {
            content
            GeometryReader { proxy in
                let x = proxy.frame(in: .named(coordinateSpace)).minX
                let y = proxy.frame(in: .named(coordinateSpace)).minY
                Color.clear.preference(key: ScrollViewOffsetPreferenceKey.self, value: CGPoint(x: x * -1, y: y * -1))
            }
        }
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            offset = value
        }
    }
}

extension View {
    func readingScrollView(from coordinateSpace: String, into binding: Binding<CGPoint>) -> some View {
        modifier(ScrollViewOffsetModifier(coordinateSpace: coordinateSpace, offset: binding))
    }
}

// Sample usage:
struct CarouselView: View {
    let items = (0..<10).map({ $0 })
    
    @State var offset: CGPoint = .zero
    
    var body: some View {
        VStack {
            Text("Offset: \(offset.y)")
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(items, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .frame(width: 90, height: 90)
                            .foregroundColor(.blue)
                    }
                }
                .readingScrollView(from: "scroll", into: $offset)
            }
            .background(offset.y > 50 ? Color(.blue) : Color(.green))
            .coordinateSpace(name: "scroll")
        }
    }
}
