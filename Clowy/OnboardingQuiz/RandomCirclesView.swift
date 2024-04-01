//
//  RandomCirclesView.swift
//  Clowy
//
//  Created by Егор Карпухин on 10.03.2024.
//

import SwiftUI

struct RandomCirclesView: View {
    let index: Int
    let currentPage: Int
    let weathers: [WeatherCircle] = [
            WeatherCircle(number: 0, weatherName: "Sunny", weatherIcon: "CustomSunIcon", color: .secondaryBlueBrand, size: 120, iconWidth: 61, iconHeight: 61, widthOffset: 0, heightOffset: 0, padding: 0),
            WeatherCircle(number: 1, weatherName: "Mainly cloudy", weatherIcon: "CustomCloudIcon", color: .secondaryBlueBrand, size: 144, iconWidth: 74, iconHeight: 64, widthOffset: 40, heightOffset: 0, padding: 0),
            WeatherCircle(number: 2, weatherName: "Windy", weatherIcon: "CustomWindIcon", color: .primaryOrangeBrand, size: 120, iconWidth: 70, iconHeight: 21, widthOffset: 24, heightOffset: 7, padding: 0),
            WeatherCircle(number: 3, weatherName: "Rain", weatherIcon: "CustomRainIcon", color: .primaryOrangeBrand, size: 120, iconWidth: 80, iconHeight: 58, widthOffset: 0, heightOffset: 35, padding: 0),
            WeatherCircle(number: 4, weatherName: "Snow", weatherIcon: "CustomSnowIcon", color: .secondaryBlueBrand, size: 120, iconWidth: 66, iconHeight: 62, widthOffset: 11, heightOffset: 0, padding: 0)
    ]

    
    var body: some View {
        
        HStack(alignment: .top, spacing: 40) {
            VStack(alignment: .leading, spacing: 23) {
                WeatherCircleButton(weather: weathers[0], questionIndex: index)
                    .offset(CGSize(width: weathers[0].widthOffset, height: weathers[0].heightOffset))
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0.1 : 0), value: currentPage)
                WeatherCircleButton(weather: weathers[1], questionIndex: index)
                    .offset(CGSize(width: weathers[1].widthOffset, height: weathers[1].heightOffset))
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0.15 : 0), value: currentPage)
                WeatherCircleButton(weather: weathers[2], questionIndex: index)
                    .offset(CGSize(width: weathers[2].widthOffset, height: weathers[2].heightOffset))
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0.2 : 0), value: currentPage)
            }
            
            VStack(alignment: .trailing, spacing: 130) {
                WeatherCircleButton(weather: weathers[3], questionIndex: index)
                    .offset(CGSize(width: weathers[3].widthOffset, height: weathers[3].heightOffset))
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0.25 : 0), value: currentPage)
                WeatherCircleButton(weather: weathers[4], questionIndex: index)
                    .offset(CGSize(width: weathers[4].widthOffset, height: weathers[4].heightOffset))
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0.3 : 0), value: currentPage)
            }
        }
        .frame(maxHeight: 500)
        .padding(.horizontal, 24)
    }
}


struct WeatherCircle: Identifiable, Hashable {
    let id = UUID()
    let number: Int32
    let weatherName: String
    let weatherIcon: String
    let color: Color
    let size: CGFloat
    let iconWidth: CGFloat
    let iconHeight: CGFloat
    let widthOffset: Double
    let heightOffset: Double
    let padding: Double
}

struct WeatherCircleList: Hashable {
    let content: [WeatherCircle]
    
    let padding: Double
}

struct WeatherCircleButton: View {
    @StateObject var viewModel = OnboardingQuizViewModel.shared
    let weather: WeatherCircle
    let questionIndex: Int
    
    var body: some View {
        ZStack {
            Circle()
                .frame(minWidth: weather.size, maxWidth: weather.size*1.2)
                .foregroundStyle(viewModel.questions[ questionIndex-1].answer.contains(weather.weatherName) ? weather.color : Color.notChosenCircle)
            VStack(spacing: 10) {
                Image(weather.weatherIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: weather.iconWidth, height: weather.iconHeight)
                Text(weather.weatherName)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .multilineTextAlignment(.center)
                    .frame(minWidth: weather.size*0.7, maxWidth: weather.size*1.2*0.7)
                    .foregroundColor(viewModel.questions[ questionIndex-1].answer.contains(weather.weatherName) ? Color.white : Color(hex: "#425987"))
            }
        }
        .onTapGesture {
            if viewModel.questions[questionIndex-1].answer.contains(weather.weatherName) {
                let index = viewModel.questions[questionIndex-1].answer.firstIndex(of: weather.weatherName)!
                viewModel.questions[questionIndex-1].answer.remove(at: index)
            } else {
                viewModel.questions[questionIndex-1].answer.append(weather.weatherName)
            }
        }
    }
}
