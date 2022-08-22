//
//  AddPhotoView.swift
//  MyCombineProject
//
//  Created by Егор Карпухин on 19.01.2022.
//

import SwiftUI

struct UsePhotoFromGalary: View {
    var body: some View {
        ZStack (alignment: .center) {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "#DADADA"), style: StrokeStyle(lineWidth: 1, dash: [4]))
            
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .frame(width: 46, height: 46)
                        .foregroundColor(Color(hex: "#678CD4"))
                        .opacity(0.2)
                    Image(systemName: "photo")
                        .foregroundColor(Color(hex: "#678CD4"))
                }
                Text("Use photo\nfrom galery")
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(Color(hex: "#606060"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .frame(height: 133)
    }
}

struct UseStockPhoto: View {
    var body: some View {
        ZStack (alignment: .center) {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(hex: "#DADADA"), style: StrokeStyle(lineWidth: 1, dash: [4]))
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .frame(width: 46, height: 46)
                        .foregroundColor(Color(hex: "#678CD4"))
                        .opacity(0.2)
                    Image(systemName: "tshirt")
                        .foregroundColor(Color(hex: "#678CD4"))
                }
                Text("Choose category to\nuse stock photo")
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(Color(hex: "#606060"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            
        }
        .frame(height: 133)
    }
}
