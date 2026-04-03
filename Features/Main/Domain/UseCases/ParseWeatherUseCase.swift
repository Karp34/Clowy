//
//  ParseWeatherUseCaseProtocol.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//

import SwiftUI

protocol ParseWeatherUseCaseProtocol {
    func execute(data: ResponseBodyForecastAPI) -> [WeatherDay]
}

final class ParseWeatherUseCase: ParseWeatherUseCaseProtocol {

    func execute(data: ResponseBodyForecastAPI) -> [WeatherDay] {
        guard data.cod == "200", !data.list.isEmpty else { return [] }

        var days = [WeatherDay]()

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(data.city.timezone))

        let firstDaySeconds = Date(timeIntervalSince1970: TimeInterval(data.list[0].dt + Int(data.city.timezone)))
        let firstLocalDate = dateFormatter.string(from: firstDaySeconds)

        var tempListResponse = [WeatherDay]()
        var nextDayTempList = [WeatherDay]()
        var weatherList = [String]()

        for index in 0..<data.list.count {
            let item = data.list[index]
            let newDaySeconds = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let newLocalDate = dateFormatter.string(from: newDaySeconds)
            let newFullDate = item.dt_txt.components(separatedBy: " ")

            let code = item.weather[0].id
            let weatherName = item.weather[0].main
            let temp = item.main.temp_min
            let humidity = item.main.humidity
            let windSpeed = item.wind.speed
            let iconAndColor = getIconAndColor(statusCode: code, dayTime: nil, hourInt: nil)

            if firstLocalDate == newLocalDate {
                let hourFormatter = DateFormatter()
                hourFormatter.dateFormat = "H"
                hourFormatter.timeZone = TimeZone(secondsFromGMT: Int(data.city.timezone))
                let intHour = Int(hourFormatter.string(from: newDaySeconds)) ?? 0

                if index == 0 {
                    let ic = getIconAndColor(statusCode: code, dayTime: nil, hourInt: intHour)
                    days.append(WeatherDay(
                        id: index,
                        name: "Now",
                        weather: Weather(code: code, name: weatherName, color: ic.color, icon: ic.icon,
                                        temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed))
                    ))
                } else {
                    let name = getTimeName(hour: intHour)
                    let ic = getIconAndColor(statusCode: code, dayTime: name, hourInt: nil)
                    weatherList.append(weatherName)
                    if tempListResponse.isEmpty || tempListResponse.contains(where: { $0.name == name }) {
                        tempListResponse.append(WeatherDay(
                            id: index, name: name,
                            weather: Weather(code: code, name: weatherName, color: ic.color, icon: ic.icon,
                                            temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed))
                        ))
                    } else {
                        days.append(aggregateDay(from: tempListResponse, existingCount: days.count))
                        tempListResponse.removeAll(); weatherList.removeAll()
                        tempListResponse.append(WeatherDay(
                            id: days.count, name: name,
                            weather: Weather(code: code, name: weatherName, color: ic.color, icon: ic.icon,
                                            temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed))
                        ))
                    }
                }
            } else {
                if !tempListResponse.isEmpty {
                    days.append(aggregateDay(from: tempListResponse, existingCount: days.count))
                    tempListResponse.removeAll(); weatherList.removeAll()
                }

                let newDayTime = Int(newFullDate[1].components(separatedBy: ":")[0]) ?? 0
                if newDayTime > 5 {
                    let newDay = Int(newFullDate[0].components(separatedBy: "-")[2]) ?? 0
                    let calendar = Calendar.current
                    let anchor = calendar.dateComponents([.day, .month], from: Date())
                    let dayInt = newDay - (anchor.day ?? 0)
                    let newMonth = Int(newFullDate[0].components(separatedBy: "-")[1]) ?? 0
                    let name = newMonth == (anchor.month ?? 0) && dayInt <= 1
                        ? "Tomorrow"
                        : getDayName(date: newFullDate[0])

                    weatherList.append(weatherName)
                    if nextDayTempList.isEmpty || nextDayTempList.contains(where: { $0.name == name }) {
                        nextDayTempList.append(WeatherDay(
                            id: index, name: name,
                            weather: Weather(code: code, name: weatherName, color: iconAndColor.color, icon: iconAndColor.icon,
                                            temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed))
                        ))
                    } else {
                        days.append(aggregateDay(from: nextDayTempList, existingCount: days.count))
                        nextDayTempList.removeAll(); weatherList.removeAll()
                        nextDayTempList.append(WeatherDay(
                            id: days.count, name: name,
                            weather: Weather(code: code, name: weatherName, color: iconAndColor.color, icon: iconAndColor.icon,
                                            temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed))
                        ))
                    }

                    if index == data.list.count - 1 {
                        days.append(aggregateDay(from: nextDayTempList, existingCount: days.count))
                        nextDayTempList.removeAll(); weatherList.removeAll()
                    }
                }
            }
        }

        return days
    }

    // MARK: - Private helpers

    private func aggregateDay(from list: [WeatherDay], existingCount: Int) -> WeatherDay {
        var tempSum = 0, humiditySum = 0, windSum = 0
        var icons = [String](), colors = [Color](), names = [String](), codes = [Double]()

        for item in list {
            tempSum += item.weather.temp
            humiditySum += item.weather.humidity
            windSum += item.weather.windSpeed
            icons.append(item.weather.icon)
            colors.append(item.weather.color)
            names.append(item.weather.name)
            codes.append(item.weather.code)
        }

        let count = list.count
        let countedSet = NSCountedSet(array: names)
        let dominantName = countedSet.max { countedSet.count(for: $0) < countedSet.count(for: $1) } as! String
        let position = names.firstIndex(of: dominantName)!

        return WeatherDay(
            id: existingCount,
            name: list[0].name,
            weather: Weather(
                code: codes[position],
                name: dominantName,
                color: colors[position],
                icon: icons[position],
                temp: tempSum / count,
                humidity: humiditySum / count,
                windSpeed: windSum / count
            )
        )
    }

    private func getTimeName(hour: Int) -> String {
        switch hour {
        case 7..<12:  return "Morning"
        case 12:      return "Noon"
        case 13..<18: return "Afternoon"
        case 18..<22: return "Evening"
        default:      return "Night"
        }
    }

    private func getDayName(date: String) -> String {
        let formatter0 = DateFormatter(); formatter0.dateFormat = "yy-MM-dd"
        guard let d = formatter0.date(from: date) else { return "" }
        let formatter1 = DateFormatter(); formatter1.dateFormat = "EEEE"
        return formatter1.string(from: d)
    }

    // MARK: - Icon & color mapping

    private struct IconAndColor { var icon: String; var color: Color }

    private func getIconAndColor(statusCode: Double, dayTime: String?, hourInt: Int?) -> IconAndColor {
        var result = IconAndColor(icon: "", color: .clear)
        let time = hourInt.map { getTimeName(hour: $0) } ?? dayTime ?? ""

        switch true {
        case String(statusCode).hasPrefix("2"):
            result.icon = "CustomCloudBoltIcon"; result.color = Color.bolt
        case String(statusCode).hasPrefix("3"):
            result.icon = "CustomRainIcon";      result.color = Color.drizzle
        case String(statusCode).hasPrefix("5"):
            result.icon = "CustomRainIcon";      result.color = Color.rain
        case String(statusCode).hasPrefix("6"):
            result.icon = "CustomSnowIcon";      result.color = Color.snow
        case String(statusCode).hasPrefix("7"):
            result.icon = "CustomCloudIcon";     result.color = Color.smoke
        case String(statusCode).hasPrefix("8"):
            if statusCode == 800 {
                switch time {
                case "Night":     result.icon = "moon.stars.fill";      result.color = Color.night
                case "Morning":   result.icon = "sun.and.horizon.fill"; result.color = Color.morning
                case "Noon":      result.icon = "CustomSunIcon";        result.color = Color.noon
                case "Afternoon": result.icon = "CustomSunIcon";        result.color = Color.afternoon
                case "Evening":   result.icon = "sun.and.horizon.fill"; result.color = Color.evening
                default:          result.icon = "CustomSunIcon";        result.color = Color.noon
                }
            } else if statusCode == 801 {
                switch time {
                case "Night":     result.icon = "moon.stars.fill";      result.color = Color.night
                case "Morning":   result.icon = "sun.and.horizon.fill"; result.color = Color.morning
                case "Noon":      result.icon = "CustomCloudSunIcon";   result.color = Color.noon
                case "Afternoon": result.icon = "CustomCloudSunIcon";   result.color = Color.afternoon
                case "Evening":   result.icon = "sun.and.horizon.fill"; result.color = Color.evening
                default:          result.icon = "CustomCloudSunIcon";   result.color = Color.noon
                }
            } else {
                result.icon = "CustomCloudIcon"; result.color = Color.clouds
            }
        default: break
        }

        return result
    }
}
