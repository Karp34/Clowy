//
//  WeatherForecastView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 14.04.2022.
//

import SwiftUI

struct WeatherForecastView: View {
    var color: String
    var temp: String
    var icon: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20.0)
                .foregroundColor((Color(hex: color)))
                .frame(height: 88.0)
            HStack{
                Text(temp)
                    .font(.custom("Montserrat-Medium", size: 32))
                    .multilineTextAlignment(.center)
                    .frame(width: 70)
                VStack(alignment: .leading) {
                    Text("Moscow, Taganka")
                        .font(.custom("Montserrat-Bold", size: 14))
                    Text("Cloudy")
                        .font(.custom("Montserrat-Regular", size: 12))
                }
                .frame(width: 180)
                Spacer()
                Image(systemName: icon)
                    .font(.largeTitle)
                    .padding()
                    .frame(width: 56, height: 56)
            }
            .foregroundColor(.white)
            .padding()
        }
        .padding(.bottom)
    }
}
