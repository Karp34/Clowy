//
//  StyleCircles.swift
//  Clowy
//
//  Created by Егор Карпухин on 18.03.2024.
//

import SwiftUI

struct StyleCircles: View {
    @StateObject var viewModel = OnboardingQuizViewModel.shared
    
    let styles: [OnboardingStyleCircle] = [
        OnboardingStyleCircle(icon: "👕", style: "Casual", size: 144),
        OnboardingStyleCircle(icon: "👩‍💼", style: "Classic / Business", size: 178),
        OnboardingStyleCircle(icon: "🏂", style: "Sports", size: 144)
    ]
    let index: Int
    let currentPage: Int
    
    var body: some View {
        HStack(spacing: 38) {
            VStack(spacing: 58) {
                ZStack {
                    Circle()
                        .frame(width: styles[0].size)
                        .foregroundStyle(viewModel.chosenStyle == styles[0] ? Color.secondaryBlueBrand : Color.notChosenCircle)
                    VStack(spacing: 10) {
                        Text(styles[0].icon)
                            .font(.system(size: 55))
                        Text(styles[0].style)
                            .font(.custom("Montserrat-Bold", size: 14))
                            .foregroundColor(viewModel.chosenStyle == styles[0] ? Color.white : Color(hex: "#425987"))
                    }
                }
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0.2 : 0), value: currentPage)
                .onTapGesture {
                    if viewModel.chosenStyle == styles[0] {
                        viewModel.chosenStyle = OnboardingStyleCircle(icon: "", style: "", size: 0)
                    } else {
                        viewModel.chosenStyle = styles[0]
                    }
                }
                
                ZStack {
                    Circle()
                        .frame(width: styles[1].size)
                        .foregroundStyle(viewModel.chosenStyle == styles[1] ? Color.secondaryBlueBrand : Color.notChosenCircle)
                    VStack(spacing: 10) {
                        Text(styles[1].icon)
                            .font(.system(size: 55))
                        Text(styles[1].style)
                            .font(.custom("Montserrat-Bold", size: 14))
                            .foregroundColor(viewModel.chosenStyle == styles[1] ? Color.white : Color(hex: "#425987"))
                    }
                    .padding(.bottom, 8)
                }
                .offset(CGSize(width: 44, height: 0))
                .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(0.1), value: currentPage)
                .onTapGesture {
                    if viewModel.chosenStyle == styles[1] {
                        viewModel.chosenStyle = OnboardingStyleCircle(icon: "", style: "", size: 0)
                    } else {
                        viewModel.chosenStyle = styles[1]
                    }
                }
            }
            ZStack {
                Circle()
                    .frame(width: styles[2].size)
                    .foregroundStyle(viewModel.chosenStyle == styles[2] ? Color.secondaryBlueBrand : Color.notChosenCircle)
                VStack(spacing: 10) {
                    Text(styles[2].icon)
                        .font(.system(size: 55))
                    Text(styles[2].style)
                        .font(.custom("Montserrat-Bold", size: 14))
                        .foregroundColor(viewModel.chosenStyle == styles[2] ? Color.white : Color(hex: "#425987"))
                }
            }
            .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0 : 0.2), value: currentPage)
            .onTapGesture {
                if viewModel.chosenStyle == styles[2] {
                    viewModel.chosenStyle = OnboardingStyleCircle(icon: "", style: "", size: 0)
                } else {
                    viewModel.chosenStyle = styles[2]
                }
            }
        }
    }
}
