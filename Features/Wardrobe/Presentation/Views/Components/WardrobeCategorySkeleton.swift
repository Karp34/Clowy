//
//  WardrobeCategorySkeleton.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI

struct WardrobeCategorySkeleton: View {
    private let insets = EdgeInsets(top: 16, leading: 24, bottom: 24, trailing: 24)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            RoundedRectangle(cornerRadius: 16)
                .frame(width: 193, height: 26)
                .padding(.leading, 24)
                .foregroundColor(Color.secondaryGrey)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<3, id: \.self) { _ in
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(.white)
                                .frame(width: 128, height: 164)
                            VStack(spacing: 28) {
                                Circle()
                                    .foregroundColor(Color.secondaryGrey)
                                    .frame(width: 56, height: 56)
                                RoundedRectangle(cornerRadius: 16)
                                    .frame(width: 86, height: 14)
                                    .foregroundColor(Color.secondaryGrey)
                            }
                            .frame(height: 128)
                        }
                        .shadow(color: Color.shadowGrey.opacity(0.1), radius: 10, y: 4)
                    }
                }
                .padding(insets)
            }
        }
    }
}