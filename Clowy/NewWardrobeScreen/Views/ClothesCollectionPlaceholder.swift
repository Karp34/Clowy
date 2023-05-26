//
//  ClothesCollectionPlaceholder.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 29.10.2022.
//

import SwiftUI

struct ClothesCollectionPlaceholder: View {
    var count: Int?
    let insets = EdgeInsets(top: 16, leading: 24, bottom: 24, trailing: 24)
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0) {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 193, height: 26)
                    .padding(.leading, 24)
                    .foregroundColor(Color(hex: "#EEEFF1"))
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<3, id:\.self) { cloth in
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(.white)
                                .frame(width: 128, height: 164)
                            
                            VStack(spacing: 28) {
                                Circle()
                                    .foregroundColor(Color(hex: "#EEEFF1"))
                                    .frame(width: 56, height: 56)
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .frame(width: 86, height: 14)
                                    .foregroundColor(Color(hex: "#EEEFF1"))
                            }
                            .frame(height: 128)
                        }
                        .shadow(color:Color(hex: "#646C75").opacity(0.1), radius: 10, y: 4)
                    }
                }
                .padding(insets)
            }
        }
    }
}
