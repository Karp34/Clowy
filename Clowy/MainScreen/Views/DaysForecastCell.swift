//
//  DaysForecastCell.swift
//  Clowy2
//
//  Created by Егор Карпухин on 15.04.2022.
//

import SwiftUI

struct DaysForecastCell: View {
    var selected: Bool
    var day: Day
    
    var body: some View {
        HStack {
            if selected {
                Text(day.name)
                    .font(.custom("Montserrat-Bald", size: 24))
                    .foregroundColor(Color(hex: "#646C75"))
                HStack(spacing: 2) {
                    Image(systemName: day.weather.icon)
                    if day.weather.temp > 0 {
                        Text("+"+String(day.weather.temp)+"°")
                            .font(.custom("Montserrat-Medium", size: 12))
                    }
                    else if day.weather.temp < 0 {
                    Text("-"+String(day.weather.temp)+"°")
                        .font(.custom("Montserrat-Medium", size: 12))
                    } else {
                        Text(String(day.weather.temp)+"°")
                            .font(.custom("Montserrat-Medium", size: 12))
                    }
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .font(.footnote)
                .foregroundColor(.white)
                .background(Color(hex: day.weather.color))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.trailing)
                
            } else {
                Text(day.name)
                    .font(.custom("Montserrat-Bald", size: 24))
                    .foregroundColor(Color(hex: "#646C75").opacity(0.3))
                    .padding(.trailing)
            }
        }
    }
}
