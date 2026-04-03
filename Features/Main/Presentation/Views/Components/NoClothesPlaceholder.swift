//
//  NoClothesPlaceholder.swift
//  Clowy
//
//  Created by Егор Карпухин on 09.10.2022.
//

import SwiftUI

struct NoClothesDataPlaceholder: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .frame(width: 96, height: 96)
                    .foregroundColor(Color.primaryGrey).opacity(0.2)
                Image("NoDataCloud")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .foregroundColor(Color.secondaryGrey)
            }
            Text("Failed to get weather data")
                .font(.custom("Montserrat-SemiBold", size: 20))
                .foregroundColor(Color.primaryGrey)
                .multilineTextAlignment(.center)
        }
        .frame(idealHeight: 320)
    }
}
