//
//  PlaceholderCities.swift
//  Clowy
//
//  Created by Егор Карпухин on 02.09.2022.
//

import SwiftUI

struct PlaceholderCities: View {
    @State private var activeIndex: Int = 0

    let widths: [CGFloat] = [180, 200, 100, 180, 100]
    let animationDuration: Double = 0.3

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(Array(widths.enumerated()), id: \.offset) { index, width in
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color.secondaryGrey.opacity(activeIndex == index ? 1 : 0.5))
                    .frame(width: width, height: 16)
                    .padding(.leading, 16)
                    .padding(.top, index == 0 ? 8 : 0)

                if index < widths.count - 1 {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(height: 1)
                        .foregroundColor(Color.separatorGrey)
                }
            }
        }
        .padding(.top, 30)
        .onAppear {
            startAnimation()
        }
    }

    func startAnimation() {
        for index in widths.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * animationDuration) {
                withAnimation(.easeInOut(duration: animationDuration)) {
                    activeIndex = index
                }
                if index == widths.count - 1 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                        startAnimation()
                    }
                }
            }
        }
    }
}
