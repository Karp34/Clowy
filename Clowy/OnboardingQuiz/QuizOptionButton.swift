//
//  QuizOptionButton.swift
//  Clowy
//
//  Created by Егор Карпухин on 11.03.2024.
//

import SwiftUI

struct QuizOptionButton: View {
    var options: [String]
    var withCheckpoints: Bool
    @State var chosenOptions: [String] = []
    
    var body: some View {
        VStack(spacing: 24) {
            ForEach(options, id:\.self) { option in
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
                            .foregroundColor(Color.primaryBackground)
                        RoundedRectangle(cornerRadius: 43)
                            .stroke(chosenOptions.contains(option) ? Color.secondaryBlueBrand : Color.secondaryBlueBrand.opacity(0.5), style: StrokeStyle(lineWidth: 3))
                        Text(option)
                            .font(.custom("Montserrat-ExtraBold", size: 16))
                            .foregroundColor(Color.secondaryBlueBrand)
                    }
                    .frame(height: 52)
                    .onTapGesture {
                        if chosenOptions.contains(option) {
                            let index = chosenOptions.firstIndex(of: option)!
                            chosenOptions.remove(at: index)
                        } else {
                            chosenOptions.append(option)
                        }
                    }
                }
            }
        }
        .padding(24)
    }
}
