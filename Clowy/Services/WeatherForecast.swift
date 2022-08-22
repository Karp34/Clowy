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
        let dayNumber = Calendar.current.component(.weekday, from: Date())
        let weatherList = [
            Weather(color: "#42AAFF", icon: "sun.max.fill", temp: "35°"),
            Weather(color: "#ABCDEF", icon: "sun.haze.fill", temp: "12°"),
            Weather(color: "#003153", icon: "cloud.moon.rain.fill", temp: "2°"),
            Weather(color: "#4285B4", icon: "cloud.bolt.fill", temp: "0°"),
            Weather(color: "#3E5F8A", icon: "cloud.drizzle.fill", temp: "-3°"),
            Weather(color: "#606E8C", icon: "cloud.sun.rain.fill", temp: "-27°"),
            Weather(color: "#1560BD", icon: "cloud.snow.fill", temp: "-33°")
        ]
        
        for time in 0..<7 {
            var name: String
            var newHour: Int
            var nextDayNumber: Int
            if time == 0 {
                name = "Now"
            } else if time < 4 {
                newHour = hour + 5 * ( time + 1 )
                if newHour > 24 {
                    newHour = newHour - 24
                }
                name = greetingLogic(newHour)
            } else if time == 4 {
                name = "Tomorrow"
            } else {
                nextDayNumber = dayNumber + time - 4
                if nextDayNumber > 7 {
                    nextDayNumber = nextDayNumber - 7
                }
                name = dayName(nextDayNumber)
            }
            daysList.append(Day(id: time, name: name, weather: weatherList[time]))
        }
        return daysList
//        [
//            Day(id: 0, name: "Now", weather: Weather(color: "#42AAFF", icon: "sun.max.fill", temp: "35°")),
//            Day(id: 1, name: greetingLogic(hour), weather: Weather(color: "#ABCDEF", icon: "sun.haze.fill", temp: "12°")),
//            Day(id: 2, name: "Night", weather: Weather(color: "#003153", icon: "cloud.moon.rain.fill", temp: "2°")),
//            Day(id: 3, name: "Thursday", weather: Weather(color: "#4285B4", icon: "cloud.bolt.fill", temp: "0°")),
//            Day(id: 4, name: "Friday", weather: Weather(color: "#3E5F8A", icon: "cloud.drizzle.fill", temp: "-3°")),
//            Day(id: 5, name: "Saturday", weather: Weather(color: "#606E8C", icon: "cloud.sun.rain.fill", temp: "-27°")),
//            Day(id: 6, name: "Sunday", weather: Weather(color: "#1560BD", icon: "cloud.snow.fill", temp: "-33°"))
//        ]
    }
}
