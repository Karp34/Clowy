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

//    let weathers: [WeatherCircleList] = [
//        WeatherCircleList(content: [
//            WeatherCircle(number: 0, weatherName: "Snow", weatherIcon: "CustomSnowIcon", color: .secondaryBlueBrand, size: 152, iconWidth: 74, iconHeight: 64),
//            WeatherCircle(number: 1, weatherName: "Windy", weatherIcon: "CustomWindIcon", color: .primaryOrangeBrand, size: 152, iconWidth: 70, iconHeight: 21)],
//                          widthOffset: 20, heightOffset: 0, padding: 0),
//        WeatherCircleList(content: [
//            WeatherCircle(number: 2, weatherName: "Sunny", weatherIcon: "CustomSunIcon", color: .secondaryBlueBrand, size: 212, iconWidth: 61, iconHeight: 61)],
//                          widthOffset: 0, heightOffset: 0, padding: 0),
//        WeatherCircleList(content: [
//            WeatherCircle(number: 3, weatherName: "Mainly cloudy", weatherIcon: "CustomCloudIcon", color: .secondaryBlueBrand, size: 152, iconWidth: 80, iconHeight: 58),
//            WeatherCircle(number: 4, weatherName: "Rain", weatherIcon: "CustomRainIcon", color: .secondaryBlueBrand, size: 144, iconWidth: 66, iconHeight: 62)],
//                          widthOffset: -20, heightOffset: 20, padding: 30)
//    ]
    
    let weathers: [WeatherCircle] = [
            WeatherCircle(number: 0, weatherName: "Sunny", weatherIcon: "CustomSunIcon", color: .secondaryBlueBrand, size: 122, iconWidth: 61, iconHeight: 61, widthOffset: 0, heightOffset: 0, padding: 0),
            WeatherCircle(number: 1, weatherName: "Snow", weatherIcon: "CustomSnowIcon", color: .secondaryBlueBrand, size: 144, iconWidth: 74, iconHeight: 64, widthOffset: 47, heightOffset: 0, padding: 0),
            WeatherCircle(number: 2, weatherName: "Windy", weatherIcon: "CustomWindIcon", color: .primaryOrangeBrand, size: 131, iconWidth: 70, iconHeight: 21, widthOffset: 3, heightOffset: 10, padding: 0),
            WeatherCircle(number: 3, weatherName: "Mainly cloudy", weatherIcon: "CustomCloudIcon", color: .secondaryBlueBrand, size: 148, iconWidth: 80, iconHeight: 58, widthOffset: 0, heightOffset: 37, padding: 0),
            WeatherCircle(number: 4, weatherName: "Rain", weatherIcon: "CustomRainIcon", color: .secondaryBlueBrand, size: 128, iconWidth: 66, iconHeight: 62, widthOffset: -13, heightOffset: 20, padding: 0)
    ]

    
    var body: some View {
        
        HStack(alignment: .top, spacing: 40) {
            VStack(alignment: .leading, spacing: 18) {
                WeatherCircleButton(weather: weathers[0])
                    .offset(CGSize(width: weathers[0].widthOffset, height: weathers[0].heightOffset))
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0.1 : 0), value: currentPage)
                WeatherCircleButton(weather: weathers[1])
                    .offset(CGSize(width: weathers[1].widthOffset, height: weathers[1].heightOffset))
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0.15 : 0), value: currentPage)
                WeatherCircleButton(weather: weathers[2])
                    .offset(CGSize(width: weathers[2].widthOffset, height: weathers[2].heightOffset))
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0.2 : 0), value: currentPage)
            }
            
            VStack(alignment: .trailing, spacing: 80) {
                WeatherCircleButton(weather: weathers[3])
                    .offset(CGSize(width: weathers[3].widthOffset, height: weathers[3].heightOffset))
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0.25 : 0), value: currentPage)
                WeatherCircleButton(weather: weathers[4])
                    .offset(CGSize(width: weathers[4].widthOffset, height: weathers[4].heightOffset))
                    .animation(.interactiveSpring(response: 0.9, dampingFraction: 0.8, blendDuration: 0.5).delay(currentPage == index ? 0.3 : 0), value: currentPage)
            }
        }
    }
}

//        VStack {
//            ScrollViewReader { scrollView in
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 0) {
//                        ForEach(weathers, id: \.self) { weatherList in
//                            VStack(spacing: 110) {
//                                ForEach(weatherList.content, id: \.self) { weather in
//                                    ZStack {
//                                        Circle()
//                                            .frame(width: weather.size)
//                                            .foregroundStyle(chosenWeathers.contains(weather.weatherName) ? weather.color : Color.notChosenCircle)
//                                        VStack(spacing: 10) {
//                                            Image(weather.weatherIcon)
//                                                .resizable()
//                                                .scaledToFit()
//                                                .frame(width: weather.iconWidth, height: weather.iconHeight)
//                                            Text(weather.weatherName)
//                                                .font(.custom("Montserrat-Bold", size: 14))
//                                                .foregroundColor(chosenWeathers.contains(weather.weatherName) ? Color.white : Color(hex: "#425987"))
//                                        }
//                                    }
//                                    .onTapGesture {
//                                        if chosenWeathers.contains(weather.weatherName) {
//                                            let index = chosenWeathers.firstIndex(of: weather.weatherName)!
//                                            chosenWeathers.remove(at: index)
//                                        } else {
//                                            chosenWeathers.append(weather.weatherName)
//                                        }
//                                    }
//                                }
//                            }
//                            .id(weatherList)
//                            .padding(.bottom, weatherList.padding)
//                            .offset(CGSize(width: weatherList.widthOffset, height:  weatherList.heightOffset))
//                            .onAppear {
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                    withAnimation {
//                                        scrollView.scrollTo(weathers[1], anchor: .center)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        .background(Color.primaryBackground)
//    }
//}

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
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: weather.size)
                .foregroundStyle(viewModel.chosenWeathers.contains(weather.weatherName) ? weather.color : Color.notChosenCircle)
            VStack(spacing: 10) {
                Image(weather.weatherIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: weather.iconWidth, height: weather.iconHeight)
                Text(weather.weatherName)
                    .font(.custom("Montserrat-SemiBold", size: 14))
                    .foregroundColor(viewModel.chosenWeathers.contains(weather.weatherName) ? Color.white : Color(hex: "#425987"))
            }
        }
        .onTapGesture {
            if viewModel.chosenWeathers.contains(weather.weatherName) {
                let index = viewModel.chosenWeathers.firstIndex(of: weather.weatherName)!
                viewModel.chosenWeathers.remove(at: index)
            } else {
                viewModel.chosenWeathers.append(weather.weatherName)
            }
        }
    }
}
