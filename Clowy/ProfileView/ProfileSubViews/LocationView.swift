//
//  LocationView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI

struct LocationView: View {
    @StateObject private var viewModel = MainScreenViewModel.shared
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            VStack(spacing: 8) {
                HStack {
                    Text("Your location")
                        .foregroundColor(Color(hex: "#646C75"))
                        .font(.custom("Montserrat-Medium", size: 16))
                    Spacer()
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(Color(hex: "#74A3FF"))
                        .frame(height: 56)
                    HStack {
                        Text(UserDefaults.standard.string(forKey: "location")!)
                            .foregroundColor(.white)
                            .font(.custom("Montserrat-Bold", size: 16))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        HStack(spacing: 2) {
                            Image(systemName: viewModel.chosenWeather.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 10)
                            
                            Text( (viewModel.chosenWeather.temp > 0 ? "+" : "") + String(viewModel.chosenWeather.temp) + "°")
                                .font(.custom("Montserrat-Medium", size: 12))
                                
                        }
                        .padding(.horizontal, 5)
                        .padding(.vertical, 3)
                        .foregroundColor(Color(hex: "#74A3FF"))
                        .background(Color(.white))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 16)
                    .onDisappear {
                        print("APPEAR")
                        print(UserDefaults.standard.string(forKey: "location"))
                        print(viewModel.chosenWeather)
                    }
                }
                
            }
            .padding(16)
        }
        .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
    }
}
