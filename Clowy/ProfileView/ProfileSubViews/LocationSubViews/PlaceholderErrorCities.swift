//
//  PlaceHolderErrorCities.swift
//  Clowy
//
//  Created by Егор Карпухин on 12.10.2022.
//

import SwiftUI

struct PlaceholderErrorCities: View {
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .frame(width: 96, height: 96)
                        .foregroundColor(Color(hex: "#B1B4B8")).opacity(0.2)
                    Image("NoDataCloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .foregroundColor(Color(hex: "#C6C6C8"))
                }
                Text("Failed to get locations data")
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .foregroundColor(Color(hex: "#646C75"))
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 32)
            .frame(idealHeight: 320)
            Spacer()
        }
        
    }
}

struct PlaceHolderErrorCities_Previews: PreviewProvider {
    static var previews: some View {
        PlaceholderErrorCities()
    }
}
