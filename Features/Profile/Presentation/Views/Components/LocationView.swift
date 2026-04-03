//
//  LocationView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//
import SwiftUI

struct LocationView: View {
    var chosenWeather: Weather

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16).foregroundColor(.white)
            VStack(spacing: 8) {
                HStack {
                    Text("Your location")
                        .foregroundColor(Color.primaryGrey)
                        .font(.custom("Montserrat-Medium", size: 16))
                    Spacer()
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color.secondaryBlueBrand)
                        .frame(height: 56)
                    HStack {
                        Text(UserDefaults.standard.string(forKey: "location") ?? "")
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-Bold", size: 16))
                        Spacer()
                        HStack(spacing: 2) {
                            Image(systemName: chosenWeather.icon)
                                .resizable().scaledToFit().frame(width: 12, height: 10)
                            Text((chosenWeather.temp > 0 ? "+" : "") + String(chosenWeather.temp) + "°")
                                .font(.custom("Montserrat-Medium", size: 12))
                        }
                        .padding(.horizontal, 5).padding(.vertical, 3)
                        .foregroundColor(Color.secondaryBlueBrand)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(16)
        }
        .shadow(color: Color.shadowGrey.opacity(0.1), radius: 35, x: 0, y: 8)
    }
}
