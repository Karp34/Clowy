//
//  MainScreenViewModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 14.09.2022.
//

import SwiftUI
import Foundation
import Combine
import Firebase

class MainScreenViewModel: ObservableObject {
    static var shared = MainScreenViewModel()
    
    @Published var state: PlaceHolderState = .placeholder
    @Published var stateCityName: PlaceHolderState = .placeholder
    
    @Published var weather = ResponseBodyForecastAPI(cod: "100", message: 0, cnt: 0, list: [], city: CityResponse(id: 0, name: "", country: "", population: 0, timezone: 0, sunrise: 0, sunset: 0))
    
    @Published var cityNames = [String]()
    
    @Published var chosenWeather: Weather = Weather(code: 100, name: "Default", color: "#B1B4B8", icon: "cloud", temp: 20, humidity: 99, windSpeed: 2)
    @Published var selectedId: Int = 0
    @Published var days: [Day] = []
    @Published var clothes: [Wardrobe] = []
    @Published var outfits: [Outfit] = [Outfit(id: 0, outfit: [], isGenerated: false)]
    
    func getOutfits() {
        let resultOutfits = GetOutfits.getOutfits()
        outfits = resultOutfits
    }
    
    func getClothes() {
        let resultClothes = GetClothes.getClothes()
        clothes = resultClothes
    }
    
    func changeWeather(id:Int) {
        selectedId = id
        if let weather = days.first(where: { $0.id == id })?.weather {
            chosenWeather = weather
        } else if let weather = days.first(where: { $0.id == 0 })?.weather {
            chosenWeather = weather
            self.selectedId = 0
        } else {
            chosenWeather = Weather(code: 100, name: "Clouds", color: "#B1B4B8", icon: "cloud", temp: 0, humidity: 99, windSpeed: 2)
        }
    }
        
    func getWeatherData(lat: Double?, long: Double?, locationName: String?, completion: @escaping () -> ()) {
        
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")!
        
        if lat != nil && long != nil {
            let queryItems = [URLQueryItem(name: "lat", value: String(lat!)),
                              URLQueryItem(name: "lon", value: String(long!)),
                              URLQueryItem(name: "appid", value: "b2974b730a41c731572b6e8b3ba9327d"),
                              URLQueryItem(name: "units", value: "metric")]
            urlComponents.queryItems = queryItems
            
        } else if locationName != nil {
            let queryItems = [URLQueryItem(name: "q", value: locationName),
                              URLQueryItem(name: "appid", value: "b2974b730a41c731572b6e8b3ba9327d"),
                              URLQueryItem(name: "units", value: "metric")]
            urlComponents.queryItems = queryItems
        }

        guard let url = urlComponents.url else { return }
        URLSession.shared.dataTask(with: url) { ( data, response, err ) in
            DispatchQueue.main.async {
                if let err = err {
                    print("Failed to get data from url:", err)
                    withAnimation {
                        self.state = .error
                        self.chosenWeather = Weather(code: 100, name: "Clouds", color: "#B1B4B8", icon: "cloud", temp: 0, humidity: 99, windSpeed: 2)
                    }
                    return
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    self.weather = try decoder.decode(ResponseBodyForecastAPI.self, from: data)
                    withAnimation {
                        self.state = .success
                    }
                    completion()
                } catch {
                    withAnimation {
                        self.state = .error
                        self.chosenWeather = Weather(code: 100, name: "Clouds", color: "#B1B4B8", icon: "cloud", temp: 0, humidity: 99, windSpeed: 2)
                    }
                    print(error)
                }
            }
        }.resume()
    }
    
    func getCityName(prefixName: String) {
        var urlComponents = URLComponents(string: "https://wft-geo-db.p.rapidapi.com/v1/geo/cities")!
        let queryItems = [URLQueryItem(name: "limit", value: "5"),
                          URLQueryItem(name: "minPopulation", value: "100"),
                          URLQueryItem(name: "namePrefix", value: prefixName),
                          URLQueryItem(name: "sort", value: "-population"),
                          URLQueryItem(name: "types", value: "City"),
                          URLQueryItem(name: "distanceUnit", value: "KM")]
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return }
        
        var request = URLRequest(url: url)
        let headers = [
            "X-RapidAPI-Key": "829a909363msh0b8c0e070645bf9p1034cajsn75d49f6d130b",
            "X-RapidAPI-Host": "wft-geo-db.p.rapidapi.com"
        ]
        
        URLSession.shared.dataTask(with: request) { ( data, response, err ) in
            DispatchQueue.main.async { // never, never, never sync !!
                if let err = err {
                    print("Failed to get data from url:", err)
                    withAnimation {
                        self.stateCityName = .error
                    }
                    return
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(CityNamesModel.self, from: data)
                    self.cityNames.removeAll()
                    if result.data != nil {
                        for city in result.data! {
                            let fullCityName = String(city.name + ", " + city.country)
                            let shortCityName = String(city.name + ", " + city.countryCode)
                            if fullCityName.count < 40 {
                                self.cityNames.append(fullCityName)
                            } else {
                                self.cityNames.append(shortCityName)
                            }
                            withAnimation {
                                self.stateCityName = .success
                            }
                        }
                    }
                } catch {
                    withAnimation {
                        self.stateCityName = .error
                    }
                    print(error)
                }
            }
        }.resume()
    }
    
    func getIconAndColor(statusCode: Double, dayTime: String?, hourInt: Int?) -> [String] {
        var list = [String]()
        var time: String = dayTime ?? ""
        
        if hourInt != nil && dayTime == nil {
            time = getTimeName(hour: hourInt!)
        }
        
        if String(statusCode).hasPrefix("2") {
            list = ["cloud.bolt.fill", "#2F3C55"]
        }
        else if String(statusCode).hasPrefix("3") {
            list =  ["cloud.drizzle.fill", "#90BDE6"]
        }
        else if String(statusCode).hasPrefix("5") {
            list =  ["cloud.drizzle.fill", "#354F81"]
        }
        else if String(statusCode).hasPrefix("6") {
            list =  ["cloud.snow.fill", "#8DA0E3"]
        }
        else if String(statusCode).hasPrefix("7") {
            list =  ["smoke.fill", "#C0C0C0"]
        }
        else if String(statusCode).hasPrefix("8") {
            if statusCode == 800 {
                if time != "" {
                    
                    if time == "Night" {
                        list =  ["moon.stars.fill", "#414B5B"]
                    } else if time == "Morning" {
                        list =  ["sun.and.horizon.fill", "#FFA98E"]
                    } else if time == "Noon" {
                        list =  ["sun.max.fill", "#74A3FF"]
                    } else if time == "Afternoon" {
                        list =  ["sun.max.fill", "#3E7FFF"]
                    } else if time == "Evening" {
                        list =  ["sun.and.horizon.fill", "#47395E"]
                    }
                    
                }
                
                else {
                    list =  ["sun.max.fill", "#74A3FF"]
                }
            } else if statusCode == 801 {
                if time != "" {
                    
                    if time == "Night" {
                        list =  ["moon.stars.fill", "#414B5B"]
                    } else if time == "Morning" {
                        list =  ["sun.and.horizon.fill", "#FFA98E"]
                    } else if time == "Noon" {
                        list =  ["cloud.sun.fill", "#74A3FF"]
                    } else if time == "Afternoon" {
                        list =  ["cloud.sun.fill", "#3E7FFF"]
                    } else if time == "Evening" {
                        list =  ["sun.and.horizon.fill", "#47395E"]
                    }
                    
                }
                
                else {
                    list =  ["cloud.sun.fill", "#74A3FF"]
                }
            } else {
                list =  ["cloud.fill", "#94A9D1"]
            }
        }
        
        return list
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
    
    func getDayName(dayInt: Int) -> String {
        let dayNumber = Calendar.current.component(.weekday, from: Date())
        var nextDayNumber = dayNumber + dayInt
        
        if nextDayNumber > 7 {
            nextDayNumber = nextDayNumber - 7
        }
        
        let name = dayName(nextDayNumber)
        return name
    }
    
    func getTimeName(hour: Int) -> String {
        var name = ""
        if hour >= 0 && hour <= 4 {
            name = "Night"
        }
        else if hour > 4 && hour < 12 {
            name = "Morning"
        }
        else if hour == 12 {
            name = "Noon"
        }
        else if hour > 12 && hour < 18 {
            name = "Afternoon"
        }
        else if hour >= 18 {
            name = "Evening"
        }
        
        return name
    }
    
    func getAllDayWeather(nextDayTempList: [Day], weatherList: [String], days: [Day]) -> Day {
        let endName = nextDayTempList[0].name
        
        
        var tempTemp = 0
        var tempHumidity = 0
        var tempWindSpeed = 0
        var icons = [String]()
        var colors = [String]()
        var weatherList2 = [String]()
        var codes = [Double]()
        
        for item in nextDayTempList {
            tempTemp += item.weather.temp
            tempHumidity += item.weather.humidity
            tempWindSpeed += item.weather.windSpeed
            
            icons.append(item.weather.icon)
            colors.append(item.weather.color)
            weatherList2.append(item.weather.name)
            codes.append(item.weather.code)
        }
        
        let endTemp = tempTemp / nextDayTempList.count
        let endHumidity = tempHumidity / nextDayTempList.count
        let endWindSpeed = tempWindSpeed / nextDayTempList.count
        

        let countedSetWeather = NSCountedSet(array: weatherList2)
        let endWeather = countedSetWeather.max { countedSetWeather.count(for: $0) < countedSetWeather.count(for: $1) }
        
        let position = weatherList2.firstIndex(of: endWeather as! String)
        let endColor = colors[position!]
        let endIcon = icons[position!]
        let endCode = codes[position!]
        
        let firstDay = Day(id: days.count, name: endName, weather: Weather(code: endCode, name: endWeather as! String, color: endColor, icon: endIcon, temp: endTemp, humidity: endHumidity, windSpeed: endWindSpeed))
        return firstDay
    }
    
    func parseWeatherData(data: ResponseBodyForecastAPI) -> [Day] {
        self.state = .placeholder
        var days = [Day]()
        
        if data.cod == "200" {
            
            let firstFullDate = data.list[0].dt_txt.components(separatedBy: " ")
            
            let firstDaySeconds = Date(timeIntervalSince1970: TimeInterval(data.list[0].dt + Int(data.city.timezone)) )
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(data.city.timezone))
            let firstLocalDate = dateFormatter.string(from: firstDaySeconds)
            
            
            let firstDay = (firstFullDate[0].components(separatedBy: "-")[2] as NSString).integerValue
            var tempListResponse = [Day]()
            var nextDayTempList = [Day]()
            var weatherList = [String]()
            
            for item in (0..<data.list.count) {
                print(data.list[item])
                let newDaySeconds = Date(timeIntervalSince1970: TimeInterval(data.list[item].dt))
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                dateFormatter.timeZone = TimeZone(secondsFromGMT: Int(data.city.timezone))
                let newLocalDate = dateFormatter.string(from: newDaySeconds)
                
                let id = item
                let newFullDate = data.list[item].dt_txt.components(separatedBy: " ")
                
                let code = data.list[item].weather[0].id
                let weather = data.list[item].weather[0].main
                let temp = data.list[item].main.temp_min
                let humidity = data.list[item].main.humidity
                let iconAndColor = getIconAndColor(statusCode: data.list[item].weather[0].id, dayTime: nil, hourInt: nil)
                let windSpeed = data.list[item].wind.speed
                
                if firstLocalDate == newLocalDate {
                    let hourFormatter = DateFormatter()
                    hourFormatter.dateFormat = "H"
                    hourFormatter.timeZone = TimeZone(secondsFromGMT: Int(data.city.timezone))
                    let hour = hourFormatter.string(from: newDaySeconds)
                    let intHour = (hour as NSString).integerValue
                
                    
                    if item == 0 {
                        let name = "Now"
                        let iconAndColor = getIconAndColor(statusCode: data.list[item].weather[0].id, dayTime: nil, hourInt: intHour)
                        let day = Day(id: id, name: name, weather: Weather(code: code, name: weather, color: iconAndColor[1], icon: iconAndColor[0], temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed)))
                        
                        days.append(day)
                        
                    } else {
                        let name = getTimeName(hour: intHour)
                        let iconAndColor = getIconAndColor(statusCode: data.list[item].weather[0].id, dayTime: name, hourInt: nil)
                        
                        weatherList.append(weather)
                        
                        if tempListResponse.isEmpty || tempListResponse.contains(where: {$0.name == name}) {
                            let tempDay = Day(id: id, name: name, weather: Weather(code: code, name: weather, color: iconAndColor[1], icon: iconAndColor[0], temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed)))
                            tempListResponse.append(tempDay)
                        } else {
                            let firstDay = getAllDayWeather(nextDayTempList: tempListResponse, weatherList: weatherList, days: days)
                            days.append(firstDay)
                            
                            tempListResponse.removeAll()
                            weatherList.removeAll()
                            let secondDay = Day(id: days.count, name: name, weather: Weather(code: code, name: weather, color: iconAndColor[1], icon: iconAndColor[0], temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed)))
                            tempListResponse.append(secondDay)
                        }
                    }
                    
                } else {
                    if !tempListResponse.isEmpty {
                        let firstDay = getAllDayWeather(nextDayTempList: tempListResponse, weatherList: weatherList, days: days)

                        days.append(firstDay)
                        tempListResponse.removeAll()
                        weatherList.removeAll()
                    }
                    
                    let newDayTime = (newFullDate[1].components(separatedBy: ":")[0] as NSString).integerValue
                    if newDayTime > 5 {
                        
                        let newDay = (newFullDate[0].components(separatedBy: "-")[2] as NSString).integerValue
                        
                        let calendar = Calendar.current
                        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: Date())
                        let currentDateDay = anchorComponents.day!
                        
                        let dayInt = newDay - currentDateDay
                        
                        
                        weatherList.append(weather)
                        
                        
                        let name = dayInt <= 1 ? "Tomorrow" : getDayName(dayInt: dayInt)
                        print(name)
                        if nextDayTempList.isEmpty || nextDayTempList.contains(where: {$0.name == name}) {
                            let tempDay = Day(id: id, name: name, weather: Weather(code: code, name: weather, color: iconAndColor[1], icon: iconAndColor[0], temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed)))
                            nextDayTempList.append(tempDay)
                            
                        } else {
                            let firstDay = getAllDayWeather(nextDayTempList: nextDayTempList, weatherList: weatherList, days: days)
                            days.append(firstDay)
                            
                            nextDayTempList.removeAll()
                            weatherList.removeAll()
                            let secondDay = Day(id: days.count, name: name, weather: Weather(code: code, name: weather, color: iconAndColor[1], icon: iconAndColor[0], temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed)))
                            nextDayTempList.append(secondDay)
                        }
                            
                        if item == data.list.count - 1 {
                            let firstDay = getAllDayWeather(nextDayTempList: nextDayTempList, weatherList: weatherList, days: days)
                            days.append(firstDay)
                            
                            nextDayTempList.removeAll()
                            weatherList.removeAll()
                        }
                        
                    }
                }

            }
        }
        self.state = .success
        return days
        
    }
    
    
    @Published var deviceLocationService = DeviceLocationService.shared
    @Published var tokens: Set<AnyCancellable> = []
    @Published var coordinates: (lat: Double, lon: Double) = (0, 0)
    
    func getCoordinates(completion: @escaping ((lat: Double, lon: Double)) -> () ) {
        observeCoordinateUpdates()
        observeDeniedLocationAccess()
        completion(self.coordinates)
    }
    
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }

    func observeDeniedLocationAccess() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Handle access denied event, possibly with an alert.")
            }
            .store(in: &tokens)
    }
    
    @FetchRequest(
        entity: TestCloth.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TestCloth.name, ascending: true)]
    ) var items: FetchedResults<TestCloth>
    

    
    
    
    //Log in feature
    
    @Published var userIsLoggedIn = false
    @Published var userEmail: String = ""
    @Published var userPassword: String = ""
    @Published var showSecondPage = false
    
    func register() {
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            self.userIsLoggedIn.toggle()
        }
    }
    
    func signOut() {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
