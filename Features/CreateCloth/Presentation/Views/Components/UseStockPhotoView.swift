//
//  AddPhotoView.swift
//  MyCombineProject
//
//  Created by Егор Карпухин on 19.01.2022.
//

import SwiftUI

struct UseStockPhoto: View {
    var body: some View {
        ZStack (alignment: .center) {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.separatorGrey, style: StrokeStyle(lineWidth: 1, dash: [4]))
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .frame(width: 46, height: 46)
                        .foregroundColor(Color.primaryBlueBrand)
                        .opacity(0.2)
                    Image(systemName: "tshirt")
                        .foregroundColor(Color.primaryBlueBrand)
                }
                Text("Choose category to\nuse stock photo")
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(Color.primaryGrey)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            
        }
        .frame(height: 133)
    }
}
