//
//  GetWeatherForecast.swift
//  Clowy2
//
//  Created by Егор Карпухин on 15.04.2022.
//

import Foundation

func greetingLogic(_ hour: Int) -> String {
    var greetingText: String
    
    if hour >= 5 && hour < 12 {
        greetingText = "Morning"
    } else if hour == 12 {
        greetingText = "Noon"
    } else if hour >= 13 && hour < 17 {
        greetingText = "Afternoon"
    } else if hour >= 17 && hour < 22 {
        greetingText = "Evening"
    } else {
        greetingText = "Night"
    }
    
    return greetingText
}

func dayName(_ weekDay: Int) -> String {
    var dayName: String
    
    if weekDay == 1 {
        dayName = "Sunday"
    } else if weekDay == 2 {
        dayName = "Monday"
    } else if weekDay == 3 {
        dayName = "Tuesday"
    } else if weekDay == 4 {
        dayName = "Wednesday"
    } else if weekDay == 5 {
        dayName = "Thursday"
    } else if weekDay == 6 {
        dayName = "Friday"
    } else {
        dayName = "Saturday"
    }
    
    return dayName
}

class WeatherForecast {
    static func getDays() -> [Day] {
        var daysList: [Day] = []
        let hour = Calendar.current.component(.hour, from: Date())
        let weatherList = [
            Weather(code: 802, name: "Cloudy", color: "#42AAFF", icon: "sun.max.fill", temp: 35, humidity: 99, windSpeed: 2),
            Weather(code: 802, name: "Cloudy", color: "#ABCDEF", icon: "sun.haze.fill", temp: 12, humidity: 99, windSpeed: 2),
            Weather(code: 802, name: "Cloudy", color: "#003153", icon: "cloud.moon.rain.fill", temp: 2, humidity: 99, windSpeed: 2),
            Weather(code: 802, name: "Cloudy", color: "#4285B4", icon: "cloud.bolt.fill", temp: 0, humidity: 99, windSpeed: 2),
            Weather(code: 802, name: "Cloudy", color: "#3E5F8A", icon: "cloud.drizzle.fill", temp: -3, humidity: 99, windSpeed: 2),
            Weather(code: 802, name: "Cloudy", color: "#606E8C", icon: "cloud.sun.rain.fill", temp: 27, humidity: 99, windSpeed: 2),
            Weather(code: 802, name: "Cloudy", color: "#1560BD", icon: "cloud.snow.fill", temp:-33, humidity: 99, windSpeed: 2)
        ]
        
        let dayNumber = Calendar.current.component(.weekday, from: Date())
        
        for time in 0..<5 {
            var name: String
            var nextDayNumber: Int
            if time == 0 {
                name = "Tomorrow"
            } else {
                nextDayNumber = dayNumber + time
                if nextDayNumber > 7 {
                    nextDayNumber = nextDayNumber - 7
                }
                name = dayName(nextDayNumber)
            }
        }
        return daysList
//        [
//            Day(id: 0, name: "Now", weather: Weather(code: 802, color: "#42AAFF", icon: "sun.max.fill", temp: "35°")),
//            Day(id: 1, name: greetingLogic(hour), weather: Weather(code: 802, color: "#ABCDEF", icon: "sun.haze.fill", temp: "12°")),
//            Day(id: 2, name: "Night", weather: Weather(code: 802, color: "#003153", icon: "cloud.moon.rain.fill", temp: "2°")),
//            Day(id: 3, name: "Thursday", weather: Weather(code: 802, color: "#4285B4", icon: "cloud.bolt.fill", temp: "0°")),
//            Day(id: 4, name: "Friday", weather: Weather(code: 802, color: "#3E5F8A", icon: "cloud.drizzle.fill", temp: "-3°")),
//            Day(id: 5, name: "Saturday", weather: Weather(code: 802, color: "#606E8C", icon: "cloud.sun.rain.fill", temp: "-27°")),
//            Day(id: 6, name: "Sunday", weather: Weather(code: 802, color: "#1560BD", icon: "cloud.snow.fill", temp: "-33°"))
//        ]
    }
}
