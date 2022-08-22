//
//  TempPreferenceView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI

struct TempPreferenceView: View {
    @State private var speed = 0.0
    @State private var isEditing = false
    
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            VStack(spacing: 16) {
                HStack {
                    Text("Сlothing preference")
                        .foregroundColor(Color(hex: "#646C75"))
                        .font(.custom("Montserrat-Medium", size: 16))
                    Spacer()
                }
                RoundedRectangle(cornerRadius: 3)
                    .foregroundColor(Color(hex: "#FFDDA9"))
                    .frame(height: 4)
                
                Slider(
                    value: $speed,
                    in: -10...10,
                    step: 0.5
                ) {
                    Text("Speed")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("100")
                } onEditingChanged: { editing in
                    isEditing = editing
                }
                Text("\(speed)")
                    .foregroundColor(isEditing ? .red : .blue)
                
                
                SwiftUISlider(
                        thumbColor: UIColor(
                            if value > 0 {
                                Color(hex: "#FFA929").opacity(modul)
                            } else if value == 0 {
                                Color(hex: "#D9D9D9")
                            } else {
                                Color(hex: "#6391EB").opacity(modul)
                            }
                        ),
                        minTrackColor: UIColor(getColor(value: speed)),
                        maxTrackColor: UIColor(getColor(value: speed)),
                        value: $speed
                      ).padding(.horizontal)
                
                HStack {
                    Text("Easier")
                        .foregroundColor(Color(hex: "#646C75"))
                        .font(.custom("Montserrat-Regular", size: 12))
                    Spacer()
                    Rectangle()
                        .frame(width: 1, height: 16)
                        .foregroundColor(Color(hex: "#DBE4EF"))
                    Spacer()
                    Text("Warmer")
                        .foregroundColor(Color(hex: "#646C75"))
                        .font(.custom("Montserrat-Regular", size: 12))
                }
            }
            .padding(16)
        }
        .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
    }
}
