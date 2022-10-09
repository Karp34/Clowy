//
//  PlaceholderCities.swift
//  Clowy
//
//  Created by Егор Карпухин on 02.09.2022.
//

import SwiftUI

struct PlaceholderCities: View {
    @State var timeNow = "60"
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
            var dateFormatter: DateFormatter {
                    let fmtr = DateFormatter()
                    fmtr.dateFormat = "S"
                    return fmtr
            }
    
    
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor( Int(timeNow)! % 10 == 0 ? Color(hex: "#E0E1E3").opacity(0.5) : Color(hex: "#EEEFF1") )
                .frame(width: 180, height: 14)
                .padding(.leading, 16)
                .padding(.top, 8)
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 1)
                .foregroundColor(Color(hex: "#DADADA")).opacity(0.5)
            
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor( Int(timeNow)! % 10 == 1 ? Color(hex: "#E0E1E3").opacity(0.5) : Color(hex: "#EEEFF1") )
                .frame(width: 200, height: 14)
                .padding(.leading, 16)
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 1)
                .foregroundColor(Color(hex: "#DADADA")).opacity(0.5)
            
            RoundedRectangle(cornerRadius: 14)
                .foregroundColor( Int(timeNow)! % 10 == 2 ? Color(hex: "#E0E1E3").opacity(0.5) : Color(hex: "#EEEFF1") )
                .frame(width: 100, height: 16)
                .padding(.leading, 16)
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 1)
                .foregroundColor(Color(hex: "#DADADA")).opacity(0.5)
            
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor( Int(timeNow)! % 10 == 3 ? Color(hex: "#E0E1E3").opacity(0.5) : Color(hex: "#EEEFF1") )
                .frame(width: 180, height: 14)
                .padding(.leading, 16)
            RoundedRectangle(cornerRadius: 16)
                .frame(height: 1)
                .foregroundColor(Color(hex: "#DADADA")).opacity(0.5)
            
            RoundedRectangle(cornerRadius: 14)
                .foregroundColor( Int(timeNow)! % 10 == 4 ? Color(hex: "#E0E1E3").opacity(0.5) : Color(hex: "#EEEFF1") )
                .frame(width: 100, height: 16)
                .padding(.leading, 16)
            
           
        }
        .padding(.top, 30)
        .onReceive(timer) { _ in
                self.timeNow = dateFormatter.string(from: Date())
        }
    }
}
