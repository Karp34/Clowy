//
//  ProgressBarQuiz.swift
//  Clowy
//
//  Created by Егор Карпухин on 14.03.2024.
//

import SwiftUI

struct ProgressBarQuiz: View {
    var totalPages: CGFloat
    var currentPage: CGFloat
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color(hex: "#5987DD").opacity(0.2))
                    .frame(height: 8)
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(Color.primaryOrangeBrand)
                    .frame(width: currentPage/totalPages*size.width, height: 8)
            }
            .frame(height: 8)
        }
    }
}
