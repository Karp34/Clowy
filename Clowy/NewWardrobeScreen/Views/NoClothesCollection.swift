//
//  NoClothesCollection.swift
//  Clowy
//
//  Created by Егор Карпухин on 17.01.2022.
//

import SwiftUI

struct NoClothesCollection: View {
    var name: String
    
    var body: some View {
        let insets = EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        VStack (alignment: .leading, spacing: 0) {
            Text(name)
                .font(.custom("Montserrat-SemiBold", size: 22))
                .padding(.leading, 24)
                .foregroundColor(Color(hex: "#646C75"))
            ScrollView (.horizontal, showsIndicators: false) {
                NewClothView().padding(insets)
            }
        }
    }
}
