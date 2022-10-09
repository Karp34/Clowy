//
//  ClothesLoadingPlaceholder.swift
//  Clowy
//
//  Created by Егор Карпухин on 09.10.2022.
//

import SwiftUI

struct ClothesLoadingPlaceholder: View {
    var body: some View {
        VStack {
            let insets = EdgeInsets(top: 0, leading: 24, bottom: 16, trailing: 16)

            ScrollView (.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                     RoundedRectangle(cornerRadius: 16)
                        .frame(width: 96, height: 22)
                        .foregroundColor(Color(hex: "#E0E1E3"))
                    RoundedRectangle(cornerRadius: 16)
                       .frame(width: 64, height: 22)
                       .foregroundColor(Color(hex: "#EEEFF1"))
                    RoundedRectangle(cornerRadius: 16)
                       .frame(width: 80, height: 22)
                       .foregroundColor(Color(hex: "#EEEFF1"))
                    RoundedRectangle(cornerRadius: 16)
                       .frame(width: 72, height: 22)
                       .foregroundColor(Color(hex: "#EEEFF1"))
                 }
                .padding(insets)
                
            }
            
            HStack(alignment: .top, spacing: 16) {
                RoundedRectangle(cornerRadius: 16)
                    .aspectRatio(156/164, contentMode: .fit)
                RoundedRectangle(cornerRadius: 16)
                    .aspectRatio(156/195, contentMode: .fit)
            }
            .foregroundColor(Color(hex: "EEEFF1"))
            .padding(.horizontal, 24)
        }
    }
}
