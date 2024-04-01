//
//  QuizOptionButtonWithSubtitle.swift
//  Clowy
//
//  Created by Егор Карпухин on 12.03.2024.
//

import SwiftUI

struct QuizOptionButtonWithSubtitle: View {
    @StateObject var viewModel = OnboardingQuizViewModel.shared
    var options: [[String]]
    let currentPage: Int
    let index: Int
    
    var body: some View {
        VStack(spacing: 24) {
            let chosenOption = viewModel.questions[index-1].answer
            ForEach(options, id: \.self) { option in
                let delay = Double(options.firstIndex(of: option)!+1) * 0.15
                VStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 43)
                            .foregroundColor(chosenOption.contains(option[0]) ? Color.secondaryBlueBrand : Color.primaryBackground)
                        RoundedRectangle(cornerRadius: 43)
                            .stroke(chosenOption.contains(option[0]) ? Color.secondaryBlueBrand : Color.secondaryBlueBrand.opacity(0.5), style: StrokeStyle(lineWidth: 3))
                        Text(option[0])
                            .font(.custom("Montserrat-ExtraBold", size: 16))
                            .foregroundColor(chosenOption.contains(option[0]) ? Color.white : Color.secondaryBlueBrand)
                    }
                    .frame(height: 52)
                    
                    Text(option[1])
                        .font(.custom("Montserrat-Medium", size: 14))
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color.secondaryBlueBrand)
                        .frame(height: 40)
                    
                }
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? delay : 0), value: currentPage)
                .onTapGesture {
                    viewModel.questions[index-1].answer = [option[0]]
                }
            }
        }
        .padding(.horizontal, 24)
    }
}
