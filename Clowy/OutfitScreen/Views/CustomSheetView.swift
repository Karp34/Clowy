//
//  CustomShhetView.swift
//  Clowy
//
//  Created by Егор Карпухин on 24.05.2022.
//

import SwiftUI

struct CustomSheetView<Content: View>: View {
    var radius: CGFloat
    var color: String
    var clearCornerColor: String
    let content: Content
    
    init(radius: CGFloat, color: String, clearCornerColor: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.radius = radius
        self.color = color
        self.clearCornerColor = clearCornerColor
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: radius)
                        .frame(height: radius*2)
                    Rectangle()
                        .frame(height: radius)
                }
                .frame(height: radius*2)
                Rectangle()
            }
            .foregroundColor(Color(hex: color))
            
            content
            
            VStack {
                HStack{
                    sheetAngle(radius: radius)
                        .frame(width: radius, height: radius)
                        .rotationEffect(.degrees(180))
                    Spacer()
                    sheetAngle(radius: radius)
                        .frame(width: radius, height: radius)
                        .rotationEffect(.degrees(-90))
                }
                .foregroundColor(Color(hex: clearCornerColor))
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct sheetAngle: Shape {
    var radius: CGFloat
        
    func path(in rect: CGRect) -> Path {
        let radius = radius
        let start = CGPoint(
            x: rect.minX,
            y: rect.minY
        )
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
