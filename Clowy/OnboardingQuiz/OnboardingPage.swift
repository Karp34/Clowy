//
//  OnboardingPage.swift
//  Clowy
//
//  Created by Егор Карпухин on 18.03.2024.
//

import SwiftUI

struct OnboardingPage<Content: View>: View {
    @StateObject var viewModel = OnboardingQuizViewModel.shared
    let size: CGSize
    var index: Int
    var currentPage: Int
    let content: Content
    
    init(size: CGSize, index: Int, currentPage: Int, @ViewBuilder content: () -> Content) {
        self.size = size
        self.index = index
        self.currentPage = currentPage
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ForEach(viewModel.questions, id: \.self) { question in
                    Text(question.question)
                        .font(.custom("Montserrat-Bold", size: 24))
                        .foregroundStyle(Color.black)
                        .multilineTextAlignment(.center)
                        .frame(width: 328)
                        .opacity(question.id == currentPage ? 1 : 0)
                        .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.3).delay(currentPage == index ? 0.2 : 0), value: currentPage)
                }
            }
            
            content
            
            Spacer()
        }
        .padding(.top, 28)
    }
}
