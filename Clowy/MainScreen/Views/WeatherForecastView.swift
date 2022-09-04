//
//  WeatherForecastView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 14.04.2022.
//

import SwiftUI

struct WeatherForecastView: View {
    var name: String
    var color: String
    var temp: Int
    var icon: String
    var chosenLocation = UserDefaults.standard.string(forKey: "location") ?? ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20.0)
                .foregroundColor((Color(hex: color)))
                .frame(height: 80.0)
            HStack(spacing: 0) {
                Text( (temp > 0 ? "+" : temp == 0 ? "" : "-") + String(temp) + "°")
                    .font(.custom("Montserrat-Medium", size: 32))
                    .frame(width: 80, height: 56)
                VStack(alignment: .leading, spacing: 4) {
                    Text(chosenLocation)
                        .font(.custom("Montserrat-Bold", size: 14))
                    Text(name)
                        .font(.custom("Montserrat-Regular", size: 12))
                }
                .frame(width: 180, height: 80.0)
                Spacer()
                Image(systemName: icon)
                    .font(.largeTitle)
                    .frame(width: 56, height: 56)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
        }
        .padding(.bottom)
    }
}
