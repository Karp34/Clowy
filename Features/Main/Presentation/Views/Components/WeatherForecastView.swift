//
//  WeatherForecastView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 14.04.2022.
//

import SwiftUI
import SSSwiftUIGIFView

struct WeatherForecastView: View {
    let name: String
    let color: Color
    let temp: Int
    let icon: String
    let state: MainScreenLoadingState

    // Read location label from UserDefaults (no viewModel dependency needed here)
    private let chosenLocation = UserDefaults.standard.string(forKey: "location") ?? "Location not found"

    var body: some View {
        switch state {
        case .success:  successView
        case .error:    WeatherErrorPlaceholder()
        case .placeholder: WeatherPlaceholder()
        }
    }

    // MARK: - Success

    private var successView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(color)
                .frame(height: 80)

            weatherAnimation

            HStack(spacing: 8) {
                Text((temp > 0 ? "+" : "") + "\(temp)°")
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
                .frame(height: 80)

                Spacer()

                Group {
                    if icon.hasPrefix("Custom") {
                        Image(icon).resizable()
                    } else {
                        Image(systemName: icon).resizable()
                    }
                }
                .scaledToFit()
                .frame(width: 45, height: 40)
            }
            .multilineTextAlignment(.leading)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }

    @ViewBuilder
    private var weatherAnimation: some View {
        let gifName = resolveGifName()
        if let gifName {
            SwiftUIGIFPlayerView(gifName: gifName)
                .scaledToFill()
                .frame(height: 80)
                .cornerRadius(16)
                .opacity(0.2)
                .disabled(true)
        }
    }

    private func resolveGifName() -> String? {
        switch name {
        case "Rain":   return "rain"
        case "Snow":   return "snow"
        case "Clouds": return "clouds"
        default:
            if name.hasPrefix("2") { return "thunder" }
            return nil
        }
    }
}

// MARK: - Error placeholder

struct WeatherErrorPlaceholder: View {
    private let greyColor = Color(hex: "#B1B4B8")

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(greyColor)
                .frame(height: 80)
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
    }
}

// MARK: - Loading placeholder

struct WeatherPlaceholder: View {
    private let lightGrey = Color(hex: "#E0E1E3")

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color.secondaryGrey)
                .frame(height: 80)
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 20)
                    .frame(minWidth: 56, maxWidth: 72, minHeight: 40, maxHeight: 40)
                    .foregroundColor(lightGrey)
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        RoundedRectangle(cornerRadius: 16).frame(width: 100, height: 12).foregroundColor(lightGrey)
                        RoundedRectangle(cornerRadius: 16).frame(width: 60,  height: 12).foregroundColor(lightGrey)
                    }
                    Spacer()
                }
                .frame(minWidth: 156, minHeight: 80, maxHeight: 80)
                Spacer()
                RoundedRectangle(cornerRadius: 20).foregroundColor(lightGrey).frame(width: 56, height: 40)
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
}
