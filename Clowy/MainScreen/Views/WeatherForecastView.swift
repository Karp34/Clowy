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
    var chosenLocation = UserDefaults.standard.string(forKey: "location") ?? "Location not found"
    var state: PlaceHolderState
    
    var body: some View {
        if state == .success {
            ZStack {
                RoundedRectangle(cornerRadius: 16.0)
                    .foregroundColor((Color(hex: color)))
                    .frame(height: 80.0)
                GifImage(name: "snow")
                    .frame(height: 80.0)
                    .cornerRadius(16)
                    .opacity(0.2)
                RoundedRectangle(cornerRadius: 16.0)
                    .foregroundColor(.clear)
                    .frame(height: 80.0)
                HStack(spacing: 8) {
                    Text( (temp > 0 ? "+" : "") + String(temp) + "°")
                        .font(.custom("Montserrat-Medium", size: 32))
                        .frame(height: 40)
                        .frame(minWidth: 56, maxWidth: 72)
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(chosenLocation)
                                .font(.custom("Montserrat-Bold", size: 14))
                            Text(name)
                                .font(.custom("Montserrat-Regular", size: 12))
                        }
                        Spacer()
                    }
                    .frame(minWidth: 156)
                    .frame(height: 80.0)
                    
                    Spacer()
                    Image(systemName: icon)
                        .font(.largeTitle)
                        .frame(width: 56, height: 56)
                }
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        } else if state == .error {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 16.0)
                    .foregroundColor((Color(hex: "#B1B4B8")))
                    .frame(height: 80.0)
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.circle.fill")
                    Text("Failed to get weather data")
                        .font(.custom("Montserrat-Bold", size: 14))
                }
                .padding(.leading, 16)
                .foregroundColor(.white)
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
            
        } else if state == .placeholder {
            
            ZStack {
                RoundedRectangle(cornerRadius: 16.0)
                    .foregroundColor(Color(hex: "#EEEFF1"))
                    .frame(height: 80.0)
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(minWidth: 56, maxWidth: 72)
                        .frame(height: 40)
                        .foregroundColor(Color(hex: "#E0E1E3"))
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: 100, height: 12)
                                .foregroundColor(Color(hex: "#E0E1E3"))
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: 60, height: 12)
                                .foregroundColor(Color(hex: "#E0E1E3"))
                        }
                        Spacer()
                    }
                    .frame(minWidth: 156)
                    .frame(height: 80.0)
                    
                    Spacer()
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(hex: "#E0E1E3"))
                        .frame(width: 56, height: 40)
                }
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)
        }
    }
}
