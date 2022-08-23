//
//  TempPreferenceView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI

struct TempPreferenceView: View {
    @State private var isEditing = false
    @State var sliderColor = UIColor(Color(hex: "#FFDDA9"))
    
    @State var prefTemp = UserDefaults.standard.double(forKey: "prefTemp")
    
    
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
                Text("\(prefTemp)")
                    .foregroundColor(isEditing ? .red : .blue)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(height: 4)
                        .foregroundColor( prefTemp > 0.5 ? (prefTemp > 0.75 ? Color(hex: "#FFA929") : Color(hex: "#FFDDA9") ) : (prefTemp > 0.25 ? Color(hex: "#BFD6EF") : Color(hex: "#6391EB") ))
                    SwiftUISlider(
                        thumbColor: .white,
                        minTrackColor: .clear,
                        maxTrackColor: .clear,
                        value: $prefTemp
                    )
                    .onChange(of: prefTemp) { newValue in
                        withAnimation {
                            UserDefaults.standard.set(prefTemp, forKey: "prefTemp")
                        }
                    }
                }
                
                
                HStack(alignment: .center) {
                    HStack {
                        Text("Easier")
                            .foregroundColor(Color(hex: "#646C75"))
                            .font(.custom("Montserrat-Regular", size: 12))
                        Spacer()
                    }
                    .onTapGesture {
                        prefTemp = 0
                    }
                    .frame(width: 73)
                    Spacer()
                    Rectangle()
                        .frame(width: 1, height: 16)
                        .foregroundColor(Color(hex: "#DBE4EF"))
                        .onTapGesture {
                            prefTemp = 0.5
                        }
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Warmer")
                            .foregroundColor(Color(hex: "#646C75"))
                            .font(.custom("Montserrat-Regular", size: 12))
                    }
                    .onTapGesture {
                        prefTemp = 1
                    }
                    .frame(width: 73)
                }
            }
            .padding(16)
        }
        .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
    }
}
