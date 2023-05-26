//
//  IndicatorView.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 03.12.2022.
//

import SwiftUI

struct IndicatorView: View {
    @StateObject var viewModel = MainScreenViewModel.shared
    var selectedId: Int
    let count: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id:\.self) { id in
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(Color.white.opacity(id == selectedId ? 1 : 0.5))
                    .frame(width: id == selectedId ? 32 : 8, height: 8)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 16)
        .background(Color(hex: viewModel.chosenWeather.color))
        .clipShape(
            Capsule()
        )
    }
}
