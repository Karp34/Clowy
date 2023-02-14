//
//  IndicatorView.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 03.12.2022.
//

import SwiftUI

struct IndicatorView: View {
    @State var isPressed = false
    var selectedId: Int
    let count: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id:\.self) { id in
                Circle()
                    .foregroundColor( id == selectedId ? Color.white : Color(hex: "#E0E1E3"))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .background(Color(hex: "#EEEFF1"))
        .clipShape(
            Capsule()
        )
    }
}
