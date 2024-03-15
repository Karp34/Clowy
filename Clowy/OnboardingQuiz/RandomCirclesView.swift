//
//  RandomCirclesView.swift
//  Clowy
//
//  Created by Егор Карпухин on 10.03.2024.
//

import SwiftUI

struct RandomCirclesView: View {
    @State var chosenWeathers: [String] = []

    let weathers: [WeatherCircleList] = [
        WeatherCircleList(content: [
            WeatherCircle(number: 0, weatherName: "Snow", weatherIcon: "", color: .secondaryBlueBrand, size: 152),
            WeatherCircle(number: 1, weatherName: "Windy", weatherIcon: "", color: .primaryOrangeBrand, size: 152)], 
                          widthOffset: 20, heightOffset: 0, padding: 0),
        WeatherCircleList(content: [
            WeatherCircle(number: 2, weatherName: "Sunny", weatherIcon: "", color: .secondaryBlueBrand, size: 212)], 
                          widthOffset: 0, heightOffset: 0, padding: 0),
        WeatherCircleList(content: [
            WeatherCircle(number: 3, weatherName: "Clouds", weatherIcon: "", color: .secondaryBlueBrand, size: 152),
            WeatherCircle(number: 4, weatherName: "Rain", weatherIcon: "", color: .secondaryBlueBrand, size: 144)],
                          widthOffset: -20, heightOffset: 20, padding: 30)
    ]
    
    let optionsWithSub: [QuizSubtitleOption] = [
        QuizSubtitleOption(option: "Warmer", subtitle: "I prefer dressing for warmth, cozy and snug"),
        QuizSubtitleOption(option: "Normal", subtitle: "I usually dress in a comfortable and moderate style"),
        QuizSubtitleOption(option: "Cooler", subtitle: "I lean towards cooler attire, keeping things crisp and fresh")
    ]
    
    var body: some View {
        VStack {
            ScrollViewReader { scrollView in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(weathers, id: \.self) { weatherList in
                            VStack(spacing: 110) {
                                ForEach(weatherList.content, id: \.self) { weather in
                                    ZStack {
                                        Circle()
                                            .frame(width: weather.size)
                                            .foregroundStyle(chosenWeathers.contains(weather.weatherName) ? weather.color : Color.notChosenCircle)
                                        VStack(spacing: 10) {
                                            Image(weather.weatherIcon)
                                            Text(weather.weatherName)
                                                .font(.custom("Montserrat-Bold", size: 14))
                                                .foregroundColor(chosenWeathers.contains(weather.weatherName) ? Color.white : Color(hex: "#425987"))
                                        }
                                    }
                                    .onTapGesture {
                                        if chosenWeathers.contains(weather.weatherName) {
                                            let index = chosenWeathers.firstIndex(of: weather.weatherName)!
                                            chosenWeathers.remove(at: index)
                                        } else {
                                            chosenWeathers.append(weather.weatherName)
                                        }
                                    }
                                }
                            }
                            .id(weatherList)
                            .padding(.bottom, weatherList.padding)
                            .offset(CGSize(width: weatherList.widthOffset, height:  weatherList.heightOffset))
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    withAnimation {
                                        scrollView.scrollTo(weathers[1], anchor: .center)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .background(Color.primaryBackground)
    }
}

struct WeatherCircle: Identifiable, Hashable {
    let id = UUID()
    let number: Int32
    let weatherName: String
    let weatherIcon: String
    let color: Color
    let size: CGFloat
}

struct WeatherCircleList: Hashable {
    let content: [WeatherCircle]
    let widthOffset: Double
    let heightOffset: Double
    let padding: Double
}
