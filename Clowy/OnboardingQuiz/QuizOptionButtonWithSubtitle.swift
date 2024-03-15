//
//  QuizOptionButtonWithSubtitle.swift
//  Clowy
//
//  Created by Егор Карпухин on 12.03.2024.
//

import SwiftUI

struct QuizOptionButtonWithSubtitle: View {
    var options: [QuizSubtitleOption]
    @State var chosenOptions: String = ""
    
    var body: some View {
        VStack(spacing: 24) {
            ForEach(options, id:\.self) { option in
                VStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 43)
                            .foregroundColor(Color.primaryBackground)
                        RoundedRectangle(cornerRadius: 43)
                            .stroke(chosenOptions.contains(option.option) ? Color.secondaryBlueBrand : Color.secondaryBlueBrand.opacity(0.5), style: StrokeStyle(lineWidth: 3))
                        Text(option.option)
                            .font(.custom("Montserrat-ExtraBold", size: 16))
                            .foregroundColor(Color.secondaryBlueBrand)
                    }
                    .frame(height: 52)
                    
                    Text(option.subtitle)
                        .font(.custom("Montserrat-Medium", size: 14))
                        .foregroundColor(Color.secondaryBlueBrand)
                        .frame(width: 232)
                        .multilineTextAlignment(.center)
                    
                }
                .onTapGesture {
                    chosenOptions = option.option
                }
            }
        }
        .padding(24)
    }
}

struct QuizSubtitleOption: Hashable {
    var option: String
    var subtitle: String
}
