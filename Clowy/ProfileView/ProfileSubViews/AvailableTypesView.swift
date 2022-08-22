//
//  AvailableTypesView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI

struct AvailableTypesView: View {
    var items = ["Headdresses", "Sunglasses", "Scarves", "Jackets", "Sweaters", "Thermals", "T-Shirts", "Pants", "Thermal pants", "Socks", "Sneakers", "Umbrellas", "Gloves", "Accessories"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            VStack(spacing: 16) {
                HStack {
                    Text("Select type of clothing")
                        .foregroundColor(Color(hex: "#646C75"))
                        .font(.custom("Montserrat-Medium", size: 16))
                    Spacer()
                }
                CleanTagsView(items: items)
            }
            .padding(16)
        }
        .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
    }
}

struct AvailableTypesView_Previews: PreviewProvider {
    static var previews: some View {
        AvailableTypesView()
    }
}
