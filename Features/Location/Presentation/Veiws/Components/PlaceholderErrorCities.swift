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
                        .foregroundColor(Color.primaryGrey).opacity(0.2)
                    Image("NoDataCloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .foregroundColor(Color.separatorGrey)
                }
                Text("Failed to get location data")
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .foregroundColor(Color.primaryGrey)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 32)
            .frame(idealHeight: 320)
            Spacer()
        }
        
    }
}
