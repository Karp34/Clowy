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
    var topLeftCorner: Bool? = true
    var topRightCorner: Bool? = true
    let content: Content
    
    init(radius: CGFloat, color: String, clearCornerColor: String, topLeftCorner: Bool? = true, topRightCorner: Bool? = true, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.radius = radius
        self.color = color
        self.clearCornerColor = clearCornerColor
        self.topRightCorner = topRightCorner
        self.topLeftCorner = topLeftCorner
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    ZStack(alignment: .trailing) {
                        if topLeftCorner == true {
                            Rectangle()
                                .frame(width: radius)
                        }
                        RoundedRectangle(cornerRadius: radius)
                        if topRightCorner == true {
                            Rectangle()
                                .frame(width: radius)
                        }
                    }
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
                    if topLeftCorner == true {
                        sheetAngle(radius: radius)
                            .frame(width: radius, height: radius)
                            .rotationEffect(.degrees(180))
                    }
                    Spacer()
                    if topRightCorner == true {
                        sheetAngle(radius: radius)
                            .frame(width: radius, height: radius)
                            .rotationEffect(.degrees(-90))
                    }
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
