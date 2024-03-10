//
//  RandomCirclesView.swift
//  Clowy
//
//  Created by Егор Карпухин on 10.03.2024.
//

import SwiftUI

struct RandomCirclesView: View {
    @State var chosenWeathers: [String] = []

    let weathers: [WeatherCircle] = [
        WeatherCircle(number: 0, weatherName: "Snow", weatherIcon: "", color: .secondaryBlueBrand),
        WeatherCircle(number: 1, weatherName: "Windy", weatherIcon: "", color: .primaryOrangeBrand),
        WeatherCircle(number: 2, weatherName: "Sunny", weatherIcon: "", color: .secondaryBlueBrand),
        WeatherCircle(number: 3, weatherName: "Clouds", weatherIcon: "", color: .secondaryBlueBrand),
        WeatherCircle(number: 4, weatherName: "Rain", weatherIcon: "", color: .secondaryBlueBrand)
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                VStack(spacing: 110) {
                    ZStack {
                        let weather = weathers.first(where: {$0.number == 0})!
                        ZStack {
                            Circle()
                                .frame(width: 152)
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
                        
                    
                    ZStack {
                        let weather = weathers.first(where: {$0.number == 1})!
                        ZStack {
                            Circle()
                                .frame(width: 152)
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
                .offset(CGSize(width: 20 , height: 0))

                ZStack {
                    let weather = weathers.first(where: {$0.number == 2})!
                    ZStack {
                        Circle()
                            .frame(width: 212)
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
                    
                
                VStack(spacing: 150) {
                    ZStack {
                        let weather = weathers.first(where: {$0.number == 3})!
                        ZStack {
                            Circle()
                                .frame(width: 152)
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
                    
                    ZStack {
                        let weather = weathers.first(where: {$0.number == 4})!
                        ZStack {
                            Circle()
                                .frame(width: 152)
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
                .padding(.bottom, 30)
                .offset(CGSize(width: -20 , height: 20))
            }
        }
        .background(Color.primaryBackground)
    }
}

struct RandomCirclesView_Previews: PreviewProvider {
    static var previews: some View {
        RandomCirclesView()
    }
}

struct WeatherCircle: Identifiable {
    let id = UUID()
    let number: Int32
    let weatherName: String
    let weatherIcon: String
    let color: Color
}
