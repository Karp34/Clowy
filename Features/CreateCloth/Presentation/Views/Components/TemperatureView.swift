//
//  TemperatureView.swift
//  MyCombineProject
//
//  Created by Егор Карпухин on 19.01.2022.
//

import SwiftUI

struct TemperatureView: View {
    var tempList: [Int] = [1, 2]
    var backColor: Color
    var textColor: Color
    
    var body: some View {
        HStack(spacing: 1) {
            ZStack {
                ZStack (alignment: .trailing) {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 27, height: 27)
                        .foregroundColor(backColor)
                    Rectangle()
                        .frame(width: 8, height: 27)
                        .foregroundColor(backColor)
                }
                Text(String(tempList[0]))
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
            }
            ZStack {
                ZStack (alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6)
                        .frame(width: 27, height: 27)
                        .foregroundColor(backColor)
                    Rectangle()
                        .frame(width: 8, height: 27)
                        .foregroundColor(backColor)
                }
                Text(String(tempList[1]))
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
