//
//  QuizOptionButton.swift
//  Clowy
//
//  Created by Егор Карпухин on 11.03.2024.
//

import SwiftUI

struct QuizOptionButton: View {
    let options: [String]
    let withCheckpoints: Bool
    @State var chosenOptions: [String] = []
    let currentPage: Int
    let index: Int
    
    var body: some View {
        VStack(spacing: 24) {
            ForEach(options, id:\.self) { option in
                let delay = Double(options.firstIndex(of: option)!+1) * 0.15
                if withCheckpoints {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .foregroundColor(chosenOptions.contains(option) ? Color.secondaryBlueBrand : Color.primaryBackground)
                            Circle()
                                .stroke(chosenOptions.contains(option) ? Color.secondaryBlueBrand : Color.secondaryBlueBrand.opacity(0.5), style: StrokeStyle(lineWidth: 3))
                            Image("check")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 28)
                                .foregroundStyle(chosenOptions.contains(option) ? Color.white : Color.secondaryBlueBrand.opacity(0.5))
                        }
                        .frame(width: 52, height: 52)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 43)
                                .foregroundColor(Color.primaryBackground)
                            RoundedRectangle(cornerRadius: 43)
                                .stroke(chosenOptions.contains(option) ? Color.secondaryBlueBrand : Color.secondaryBlueBrand.opacity(0.5), style: StrokeStyle(lineWidth: 3))
                            Text(option)
                                .font(.custom("Montserrat-ExtraBold", size: 16))
                                .foregroundColor(Color.secondaryBlueBrand)
                        }
                    }
                    .frame(height: 52)
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? delay : 0), value: currentPage)
                    .onTapGesture {
                        if chosenOptions.contains(option) {
                            let index = chosenOptions.firstIndex(of: option)!
                            chosenOptions.remove(at: index)
                        } else {
                            chosenOptions.append(option)
                        }
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 43)
                            .foregroundColor(chosenOptions.contains(option) ? Color.secondaryBlueBrand : Color.primaryBackground)
                        RoundedRectangle(cornerRadius: 43)
                            .stroke(chosenOptions.contains(option) ? Color.secondaryBlueBrand : Color.secondaryBlueBrand.opacity(0.5), style: StrokeStyle(lineWidth: 3))
                        Text(option)
                            .font(.custom("Montserrat-ExtraBold", size: 16))
                            .foregroundColor(chosenOptions.contains(option) ? Color.white : Color.secondaryBlueBrand)
                    }
                    .frame(height: 52)
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? delay : 0), value: currentPage)
                    .onTapGesture {
                        chosenOptions = [option]
                    }
                }
            }
        }
        .padding(24)
    }
}
