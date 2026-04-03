//
//  DaysForecastCell.swift
//  Clowy2
//
//  Created by Егор Карпухин on 15.04.2022.
//

import SwiftUI

struct DaysForecastCell: View {
    let selected: Bool
    let day: WeatherDay

    var body: some View {
        HStack {
            Text(day.name)
                .font(.custom("Montserrat-SemiBold", size: 22))
                .foregroundColor(selected ? Color.primaryGrey : Color.primaryGrey.opacity(0.3))

            if selected {
                temperatureBadge
            }
        }
    }

    private var temperatureBadge: some View {
        HStack(spacing: 2) {
            Group {
                if day.weather.icon.hasPrefix("Custom") {
                    Image(day.weather.icon).resizable()
                } else {
                    Image(systemName: day.weather.icon).resizable()
                }
            }
            .scaledToFit()
            .frame(width: 11, height: 11)

            Text((day.weather.temp > 0 ? "+" : "") + "\(day.weather.temp)°")
                .font(.custom("Montserrat-Medium", size: 12))
        }
        .padding(.horizontal, 5)
        .padding(.vertical, 3)
        .foregroundColor(.white)
        .background(day.weather.color)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
