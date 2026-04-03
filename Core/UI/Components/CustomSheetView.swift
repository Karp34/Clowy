//
//  CustomShhetView.swift
//  Clowy
//
//  Created by Егор Карпухин on 24.05.2022.
//

import SwiftUI

struct SheetAngle: Shape {
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let start = CGPoint(x: rect.minX, y: rect.minY)
        let corner = CGPoint(x: rect.maxX, y: rect.maxY)
        var p = Path()
        p.addArc(
            center: start,
            radius: radius,
            startAngle: Angle(degrees: 90),
            endAngle: Angle(degrees: 0),
            clockwise: true
        )
        p.addLine(to: corner)
        return p
    }
}

struct CustomSheetView<Content: View>: View {
    var radius: CGFloat
    var color: Color
    var clearCornerColor: Color
    var topLeftCorner: Bool = true
    var topRightCorner: Bool = true
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    ZStack(alignment: .trailing) {
                        if topLeftCorner {
                            Rectangle()
                                .frame(width: radius)
                        }
                        RoundedRectangle(cornerRadius: radius)
                        if topRightCorner {
                            Rectangle()
                                .frame(width: radius)
                        }
                    }
                    .frame(height: radius * 2)

                    Rectangle()
                        .frame(height: radius)
                }
                .frame(height: radius * 2)
                Rectangle()
            }
            .foregroundColor(color)

            content

            VStack {
                HStack {
                    if topLeftCorner {
                        SheetAngle(radius: radius)
                            .frame(width: radius, height: radius)
                            .rotationEffect(.degrees(180))
                    }
                    Spacer()
                    if topRightCorner {
                        SheetAngle(radius: radius)
                            .frame(width: radius, height: radius)
                            .rotationEffect(.degrees(-90))
                    }
                }
                .foregroundColor(clearCornerColor)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
