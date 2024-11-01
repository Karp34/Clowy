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
import FirebaseStorage
import Kingfisher
import Alamofire


class MainScreenViewModel: ObservableObject {
    static var shared = MainScreenViewModel()
    
    @Published var state: PlaceHolderState = .placeholder
    
    @Published var weather = ResponseBodyForecastAPI(cod: "100", message: 0, cnt: 0, list: [], city: CityResponse(id: 0, name: "", country: "", population: 0, timezone: 0, sunrise: 0, sunset: 0))
    
    @Published var chosenWeather: Weather = Weather(code: 100, name: "Default", color: "#B1B4B8", icon: "cloud", temp: 20, humidity: 99, windSpeed: 2)
    @Published var selectedId: Int = 0
    @Published var days: [Day] = []
    
    @Published var showAddNewClothModel = false
    
    //Remote config
    @Published var appIsLive = RemoteConfigManager.stringValue(forKey: RCKey.appIsLive)
    @Published var openWeatherAppID = RemoteConfigManager.stringValue(forKey: RCKey.openWeatherAppID)
    @Published var NormalSuperColdConfig = RemoteConfigManager.getOutfitConfig(forKey: RCKey.NormalSuperColdConfig)
    @Published var NormalColdConfig = RemoteConfigManager.getOutfitConfig(forKey: RCKey.NormalColdConfig)
    @Published var NormalColdyConfig = RemoteConfigManager.getOutfitConfig(forKey: RCKey.NormalColdyConfig)
    @Published var NormalCoolConfig = RemoteConfigManager.getOutfitConfig(forKey: RCKey.NormalCoolConfig)
    @Published var NormalRegularConfig = RemoteConfigManager.getOutfitConfig(forKey: RCKey.NormalRegularConfig)
    @Published var NormalWarmConfig = RemoteConfigManager.getOutfitConfig(forKey: RCKey.NormalWarmConfig)
    @Published var NormalHotConfig = RemoteConfigManager.getOutfitConfig(forKey: RCKey.NormalHotConfig)
    
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
        
    func getWeatherData(lat: Double?, long: Double?, locationName: String?, completion: @escaping () -> Void) {
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")!
        
        let queryItems: [URLQueryItem]
        if let lat = lat, let long = long {
            queryItems = [
                URLQueryItem(name: "lat", value: String(lat)),
                URLQueryItem(name: "lon", value: String(long)),
                URLQueryItem(name: "appid", value: self.openWeatherAppID),
                URLQueryItem(name: "units", value: "metric")
            ]
        } else if let locationName = locationName {
            queryItems = [
                URLQueryItem(name: "q", value: locationName),
                URLQueryItem(name: "appid", value: self.openWeatherAppID),
                URLQueryItem(name: "units", value: "metric")
            ]
        } else {
            self.handleError(message: "Either coordinates or location name must be provided")
            return
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            self.handleError(message: "Failed to create URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                if let error = error {
                    self.handleError(message: error.localizedDescription)
                    return
                }
                
                guard let data = data else {
                    self.handleError(message: "No data received")
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    self.weather = try decoder.decode(ResponseBodyForecastAPI.self, from: data)
                    withAnimation {
                        self.state = .success
                    }
                    completion()
                } catch {
                    self.handleError(message: error.localizedDescription)
                }
            }
        }.resume()
    }
    
    private func handleError(message: String) {
        print("Failed to get weather data: \(message)")
        withAnimation {
            self.state = .error
            self.chosenWeather = Weather(code: 100, name: "Clouds", color: "#B1B4B8", icon: "cloud", temp: 0, humidity: 99, windSpeed: 2)
        }
    }
    
    @Published var stateCityName: PlaceHolderState = .placeholder
    @Published var geonamesResponse = GeonamesResponse(totalResultsCount: 0, geonames: [])
    
    func fetchData(prefixName: String, completion: @escaping () -> () ) {
        let urlString = "https://secure.geonames.org/searchJSON?q=\(prefixName)&maxRows=10&username=clowy"
        let urlComponents = URLComponents(string: urlString)!
        guard let url = urlComponents.url else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("Failed to get data from url:", error)
                    withAnimation {
                        self.stateCityName = .error
                    }
                    return
                }
                guard let data = data else { return }
                do {
                    let decoder = JSONDecoder()
                    self.geonamesResponse = try decoder.decode(GeonamesResponse.self, from: data)
                    
                    // Create a mutable copy of geonames
                    var mutableGeonames = self.geonamesResponse.geonames
                    
                    // Sort geonames by prefix match first, then by population
                    mutableGeonames.sort { (geoname1, geoname2) -> Bool in
                        let name1 = geoname1.name.lowercased()
                        let name2 = geoname2.name.lowercased()
                        let prefix = prefixName.lowercased()
                        
                        // If both start with prefix, sort by population
                        if name1.hasPrefix(prefix) && name2.hasPrefix(prefix) {
                            let pop1 = geoname1.population ?? 0
                            let pop2 = geoname2.population ?? 0
                            return pop1 > pop2
                        }
                        // If only one starts with prefix, it comes first
                        else if name1.hasPrefix(prefix) {
                            return true
                        }
                        else if name2.hasPrefix(prefix) {
                            return false
                        }
                        // If neither starts with prefix, sort by population
                        else {
                            let pop1 = geoname1.population ?? 0
                            let pop2 = geoname2.population ?? 0
                            return pop1 > pop2
                        }
                    }
                    
                    // Remove duplicates
                    mutableGeonames = mutableGeonames.reduce(into: [Geoname]()) { (result, geoname) in
                        if !result.contains(where: { $0.name == geoname.name && $0.countryCode == geoname.countryCode }) {
                            result.append(geoname)
                        }
                    }
                    // Assign the sorted array back to geonamesResponse
                    self.geonamesResponse.geonames = mutableGeonames
                    
                    withAnimation {
                        self.stateCityName = .success
                    }
                    completion()
                } catch {
                    print("Parsing error")
                }
            }
        }
        .resume()
    }
    
    @Published var cityNames = [String]()
    func getCityName(prefixName: String, completion: @escaping () -> ()) {
        fetchData(prefixName: prefixName) {
            if self.stateCityName == .success {
                self.cityNames = []
                for geoname in self.geonamesResponse.geonames {
                    let fullCityName = String(geoname.name + ", " + geoname.countryName)
                    let shortCityName = String(geoname.name + ", " + geoname.countryCode)
                    if fullCityName.count < 40 {
                        self.cityNames.append(fullCityName)
                    } else {
                        self.cityNames.append(shortCityName)
                    }
                }
            }
            completion()
        }
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
    
    
    func getDayName(date: String) -> String {
        let dateFormatter0 = DateFormatter()
        dateFormatter0.dateFormat = "yy-MM-dd"
        let prepearedDate = dateFormatter0.date(from: date)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let name = dateFormatter.string(from: prepearedDate)
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
                        let dayName = getDayName(date: newFullDate[0])
                        
                        
                        weatherList.append(weather)
                        
                        let newMonth = (newFullDate[0].components(separatedBy: "-")[1] as NSString).integerValue
                        let currentDateMonth = anchorComponents.month!
                        
                        
                        
                        let name = newMonth == currentDateMonth && dayInt <= 1 ? "Tomorrow" : dayName
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
    
    
    @Published var coordinates: (lat: Double, lon: Double)? = nil
    @Published var useUserGeo = UserDefaults.standard.bool(forKey: "isGeoposition")
//    @Published var deviceLocationService = DeviceLocationService.shared
//    @Published var tokens: Set<AnyCancellable> = []
//    @Published var coordinates: (lat: Double, lon: Double)? = nil
//    @Published var coordinatesReceived: Bool = false
//    
//    func getCoordinates() {
//        observeCoordinateUpdates()
//        observeDeniedLocationAccess()
//    }
//    
//    func observeCoordinateUpdates() {
//        deviceLocationService.coordinatesPublisher
//            .receive(on: DispatchQueue.main)
//            .sink { completion in
//                print("Handle \(completion) for error and finished subscription.")
//            } receiveValue: { coordinates in
//                self.coordinates = (coordinates.latitude, coordinates.longitude)
//                self.coordinatesReceived = true
//            }
//            .store(in: &tokens)
//    }
//
//    func observeDeniedLocationAccess() {
//        deviceLocationService.deniedLocationAccessPublisher
//            .receive(on: DispatchQueue.main)
//            .sink {
//                print("Handle access denied event, possibly with an alert.")
//            }
//            .store(in: &tokens)
//    }
    
    @FetchRequest(
        entity: TestCloth.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TestCloth.name, ascending: true)]
    ) var items: FetchedResults<TestCloth>
    

    
    
    
    //Log in feature
    
    @Published var userIsLoggedIn = false
    @Published var userEmail: String = ""
    @Published var userPassword: String = ""
    @Published var showSecondPage = false
    @Published var userId: String = ""
    
    func register() {
        Auth.auth().createUser(withEmail: userEmail, password: userPassword) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
        }
    }
    
    func login(completion: @escaping (String?) -> ()) {
        Auth.auth().signIn(withEmail: userEmail, password: userPassword) { result, error in
            var errorMessage: String? = nil
            if error != nil {
                print(error!.localizedDescription)
                errorMessage = error!.localizedDescription
                completion(errorMessage)
            } else {
                self.getUserInfo() {
                    if self.user.didOnboarding {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                            print("did onboarding")
                            self.user.didOnboarding = true
                            self.userIsLoggedIn = true
//                        }
                    } else {
                        self.userIsLoggedIn = true
                    }
                    completion(errorMessage)
                }
            }
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
    
    func getUserId() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        userId = userID
    }
    
    func resetUserData() {
        user = User(id: "", username: "", userIcon: "", config: "", didOnboarding: false, preferedStyle: "", hatTemperature: "", isTshirtUnder: true, excludedClothes: [], skirtPairings: [], skirtWeather: [], dressPairings: [], dressWeather: [])
        clothes.removeAll()
        outfits.removeAll()
    }
    
    
    
    
    //Create and edit user's data feature
    @Published var user = User(id: "", username: "", userIcon: "", config: "", didOnboarding: false, preferedStyle: "", hatTemperature: "", isTshirtUnder: true, excludedClothes: [], skirtPairings: [], skirtWeather: [], dressPairings: [], dressWeather: [])
    
    func getUserInfo(completion: @escaping () -> ()) {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(userId)
        
        ref.getDocument { document, error in
            guard error == nil else {
                print("HERE")
                print(error!.localizedDescription)
                self.wardrobeState = .error
                return
            }
            
            if let document = document {
                if let data = document.data() {
                    let id = document.documentID
                    let username = data["username"] as? String ?? ""
                    let userIcon = data["userIcon"] as? String ?? ""
                    let config = data["config"] as? String ?? ""
                    let didOnboarding = data["didOnboarding"] as? Bool ?? false
                    let preferedStyle = data["preferedStyle"] as? String ?? ""
                    let hatTemperature = data["hatTemperature"] as? String ?? ""
                    let isTshirtUnder = data["isTshirtUnder"] as? Bool ?? false
                    let excludedClothes = data["excludedClothes"] as? [String] ?? []
                    let skirtPairings = data["skirtPairings"] as? [String] ?? []
                    let skirtWeather = data["skirtWeather"] as? [String] ?? []
                    let dressPairings = data["dressPairings"] as? [String] ?? []
                    let dressWeather = data["dressWeather"] as? [String] ?? []
                    
                    self.user = User(id: id, username: username, userIcon: userIcon, config: config, didOnboarding: didOnboarding, preferedStyle: preferedStyle, hatTemperature: hatTemperature, isTshirtUnder: isTshirtUnder, excludedClothes: excludedClothes, skirtPairings: skirtPairings, skirtWeather: skirtWeather, dressPairings: dressPairings, dressWeather: dressWeather)
                    print("User data received \(self.user)")
                    completion()
                }
            }
        }
    }
    
    func updateUser(completion: @escaping (String?) -> ()) {
        let db = Firestore.firestore()
        let ref = db.collection("Users")
        var errorMessage: String? = nil
        
        ref.document(userId).setData([
            "username": user.username,
            "userIcon": user.userIcon,
            "config" : user.config,
            "didOnboarding" : user.didOnboarding,
            "preferedStyle" : user.preferedStyle,
            "hatTemperature" : user.hatTemperature,
            "isTshirtUnder" : user.isTshirtUnder,
            "excludedClothes": user.excludedClothes,
            "skirtPairings": user.skirtPairings,
            "skirtWeather": user.skirtWeather,
            "dressPairings": user.dressPairings,
            "dressWeather": user.dressWeather
        ]) { error in
            if error != nil {
                print(error?.localizedDescription as Any)
                errorMessage = error!.localizedDescription
                completion(errorMessage)
            } else {
                completion(errorMessage)
            }
        }
    }
    
    
    
    //Wardrobe feature
    
    @Published var clothes:  [Cloth] = []
    @Published var wardrobe:  [Wardrobe] = []
    @Published var wardrobeState: PlaceHolderState = .placeholder
    
    
    func fetchClothes(completion: @escaping () -> ()) {
        clothes.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(userId).collection("Wardrobe")
        
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print("HERE")
                print(error!.localizedDescription)
                self.wardrobeState = .error
                return
            }

            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()

                    let id = document.documentID
                    let name = data["name"] as? String ?? ""
                    let type = data["type"] as? String ?? ""
                    let color = data["color"] as? String ?? ""
                    let temperature = data["temp"] as? [String] ?? []
                    let isDefault = data["isDefault"] as? Bool ?? true
                    let image = data["image"] as? String ?? ""
                    let creationDate = data["creationDate"] as? Int ?? 0
                    
                    let cloth = Cloth(id: id, name: name, type: ClothesType(rawValue: type) ?? ClothesType.blank, color: color, temperature: temperature, isDefault: isDefault, image: image, creationDate: creationDate)
                    self.clothes.append(cloth)
                    
                }
                completion()
            }
        }
    }
    
    func fetchWardrobe(completion: @escaping () -> ()) {
            wardrobe.removeAll()
//            print("Wardrobe clear")
            fetchClothes() {
                let allTypes = CreateDefaultWardrobe.getClothes()

                for type in allTypes {
                    let id = type.id
                    let type = type.clothesTypeName
                    let ratio = GetRatio.getRatio(type: type)
                    let items = self.clothes.filter { $0.type == type }
                    self.wardrobe.append(Wardrobe(id: id, clothesTypeName: type, items: items, ratio: ratio))
                }
                self.wardrobeState = .success
                completion()
            }
    }
    
    func getImage(image: String, completion: @escaping (UIImage?) -> () ) {
        let urlString = "https://firebasestorage.googleapis.com:443/v0/b/fir-app-17e8c.appspot.com/o/" + image + "?alt=media&token=2158a184-ea2d-4300-8927-8569d153101c"
        if let url = URL.init(string: urlString) {
            print("URL IS OK")
            let resource = Kingfisher.ImageResource(downloadURL: url)
            
            KingfisherManager.shared.retrieveImage(with: resource, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    print(value.source)
                    completion(value.image)
                case .failure(let value):
                    completion(nil)
                }
            }
        }
    }
    
    func getClothesByIds(_ list: [String]) -> [Cloth] {
        var clothes: [Cloth] = []
        let defaultOutfit: [String] = ["1100","1101","1102"]
        for id in list {
            if defaultOutfit.contains(id) {
                switch id {
                case "1100" :
                    clothes.append(Cloth(id: "1100", name: "", type: .tshirts, color: "#000000", temperature: ["Cold"], isDefault: true, image: "DefaultUpperWear", creationDate: 0))

                case "1101":
                    clothes.append(Cloth(id: "1101", name: "", type: .pants, color: "#000000", temperature: ["Cold"], isDefault: true, image: "DefaultPants", creationDate: 0))
                    
                case "1102":
                    clothes.append(Cloth(id: "1102", name: "", type: .sneakers, color: "#00000", temperature: ["Cold"], isDefault: true, image: "DefaultSneaker", creationDate: 0))
                default:
                    print("Logic error when creating default outfit")
                }
            } else {
                for category in wardrobe {
                    if let cloth = category.items.first(where: { $0.id == id }) {
                        clothes.append(cloth)
                    }
                }
            }
        }
        return clothes
    }
    
    func deleteCloth(cloth: Cloth) {
        print(cloth.name)
        print(cloth.id)
        print(cloth.type)
//      thnik how to delete from each outfit and delete from storage
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(userId).collection("Wardrobe").document(cloth.id)
        ref.delete { error in
            if error == nil {
                if let index = self.wardrobe.firstIndex(where: { $0.clothesTypeName == cloth.type }) {
                    self.wardrobe[index].deleteCloth(cloth)
                }
                self.clothes.removeAll { $0.id == cloth.id }
                self.deleteFromStorage(clothId: cloth.image)
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func deleteFromStorage(clothId: String) {
        let ref = Storage.storage().reference()
        let desertRef = ref.child(clothId)

        desertRef.delete { error in
          if let error = error {
              print(error.localizedDescription)
          } else {
              print("Image deleted from storage successfully")
          }
        }
    }
    
    
    
    
    // Outfit feature
    
    @Published var outfits = [Outfit]()
    @Published var outfitState: PlaceHolderState = .placeholder
    
    func fetchOutfits() {
        outfits.removeAll()
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(userId).collection("Outfits")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print("Error outfits")
                print(error!.localizedDescription)
                self.outfitState = .error
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let id = document.documentID
                    let name = data["name"] as? String ?? "No name"
                    let isGenerated = data["isGenerated"] as? Bool ?? false
                    let clothes = data["clothes"] as? [String] ?? []
                    let createDTM = data["createDTM"] as? Double ?? 0
                    
                    let outfit = Outfit(id: id, name: name, isGenerated: isGenerated, clothes: clothes, createDTM: createDTM)
                    self.outfits.append(outfit)
                }
                self.outfitState = .success
            }
        }
    }
    
    func getConfig(weather: Weather) -> [StyleOutfits] {
        
//        let temp = Double(weather.temp) + (( UserDefaults.standard.double(forKey: "prefTemp") - 0.5 ) * -10 )
        let temp = Double(weather.temp)
        var config = [StyleOutfits]()
        var configs: OutfitConfig
        var weatherTypeConfig: WeatherType = .sunny
        
        
        if temp <= -20 {
            configs = NormalSuperColdConfig
        } else if temp <= -10 && temp > -20 {
            configs = NormalColdConfig
        } else if temp <= -5 && temp > -10 {
            configs = NormalColdyConfig
        } else if temp <= 5 && temp > -5 {
            configs = NormalCoolConfig
        } else if temp <= 15 && temp > 5 {
            configs = NormalRegularConfig
        } else if temp <= 25 && temp > 15 {
            configs = NormalWarmConfig
        } else {
            configs = NormalHotConfig
        }
        
        if weather.code.description.hasPrefix("2") || weather.code.description.hasPrefix("5") || weather.code.description.hasPrefix("6") {
            weatherTypeConfig = .rain
            config = configs.weatherConfig.first(where: {$0.weather == .rain})!.clothes
        } else if weather.humidity > 65 {
            weatherTypeConfig = .humidity
            config = configs.weatherConfig.first(where: {$0.weather == .humidity})!.clothes
        } else if weather.code == 804 || weather.code == 803 || weather.windSpeed > 12 {
            weatherTypeConfig = .cloudyOrWindy
            config = configs.weatherConfig.first(where: {$0.weather == .cloudyOrWindy})!.clothes
        } else {
            weatherTypeConfig = .sunny
            config = configs.weatherConfig.first(where: {$0.weather == .sunny})!.clothes
        }
//        config = configs.weatherConfig.first(where: {$0.weather == .sunny})!.clothes
//        weatherTypeConfig = .sunny
        
        //user preferences
        //remove winter hat if temperature is higher than his preference
        let winterHatTempTypes = ["superCold", "cold", "coldy", "cool"]
        switch user.hatTemperature {
        case _ where user.hatTemperature == "-20°C and below":
            if temp > -20 {
                config = removeHatFromConfig(config: config, tempTypes: winterHatTempTypes)
            }
        case _ where user.hatTemperature == "-10°C and below":
            if temp > -10 {
                config = removeHatFromConfig(config: config, tempTypes: winterHatTempTypes)
            }
        case _ where user.hatTemperature == "0°C and below":
            if temp > 0 {
                config = removeHatFromConfig(config: config, tempTypes: winterHatTempTypes)
            }
        case _ where user.hatTemperature == "0°C and above":
            if temp > 4.9 {
                config = removeHatFromConfig(config: config, tempTypes: winterHatTempTypes)
            }
        default:
            if temp > 0 {
                config = removeHatFromConfig(config: config, tempTypes: winterHatTempTypes)
            }
        }
        
        //remove t-shirt if user doesn't wear t-shirt under sweater
        if !user.isTshirtUnder {
            config = removeTshirtFromConfig(config: config)
        }
        
        //check if there is in config outfits that don't fit user preference
        if !user.excludedClothes.isEmpty {
            let userWears: [ClothesType] = [.skirts, .dresses]
            var clothWeather: [String] = []
            for cloth in userWears {
                if cloth == .dresses {
                    clothWeather = convertClothWeatherToWeatherType(userPreference: user.dressWeather, temp: temp)
                } else {
                    clothWeather = convertClothWeatherToWeatherType(userPreference: user.skirtWeather, temp: temp)
                }
                config = removeOutfitNotFittingToUserPreference(config: config, cloth: cloth, clothWeather: clothWeather, weatherTypeConfig: weatherTypeConfig)
            }
        }
        print(config)
        return config
    }
    
    func convertClothWeatherToWeatherType(userPreference: [String], temp: Double) -> [String] {
        var output: [String] = []
        if userPreference.contains("Mainly cloudy") || userPreference.contains("Windy") {
            output.append("cloudyOrWindy")
        }
        if userPreference.contains("Sunny") {
            output.append("sunny")
        }
        if userPreference.contains("Rain") || userPreference.contains("Snow") && temp <= 3 {
            output.append("rain")
        }
//        if userPreference.isEmpty {
//            output.append("sunny")
//        }
        return output
    }
    
    func removeOutfitNotFittingToUserPreference(config :[StyleOutfits], cloth:ClothesType , clothWeather: [String], weatherTypeConfig: WeatherType) -> [StyleOutfits] {
        var fittingOutfits: [StyleOutfits] = []
        
        if user.excludedClothes.contains(cloth.rawValue.lowercased()) {
            //user doesn't wear this cloth
            for styleOutfits in config {
                let newStyle = styleOutfits.style
                var newStyleOutfits = [[ClothesPref]]()
                for outfit in styleOutfits.outfits {
                    if !outfit.contains(where: {$0.type == cloth}) {
                        newStyleOutfits.append(outfit)
                    }
                }
                fittingOutfits.append(StyleOutfits(style: newStyle, outfits: newStyleOutfits))
            }
        } else {
            for styleOutfits in config {
                let newStyle = styleOutfits.style
                var newStyleOutfits = [[ClothesPref]]()
                for outfit in styleOutfits.outfits {
                    // add outfit if it contains dress/skirt that user wears and the weather is prefered for this cloth
                    if outfit.contains(where: {$0.type == cloth}) && clothWeather.contains(weatherTypeConfig.rawValue) {
                        // if user wears clothes from outfit with skirt/dress
                        if userWearsSuchOufit(outfit: outfit, cloth: cloth) {
                            newStyleOutfits.append(outfit)
                        }
                    // else if there is no dress/skirt in outfit, just add it to the return
                    } else if !outfit.contains(where: {$0.type == cloth}) {
                        newStyleOutfits.append(outfit)
                    }
                }
                fittingOutfits.append(StyleOutfits(style: newStyle, outfits: newStyleOutfits))
            }
        }
        
        return fittingOutfits
    }
    
    func getClothTypeFromPreference(preference: String) -> ClothesType {
        var output: ClothesType = .blank
        if preference == "Jacket" {
            output = .jackets
        } else if preference == "Blazer, Suit Jacket" {
            output = .suitJackets
        } else if preference == "Cardigan, Sweater, Tutrtleneck" {
            output = .hoodies
        } else if preference == "Shirt" {
            output = . shirts
        } else if preference == "T-Shirt, Top" {
            output = .tshirts
        } else if preference == "Leggins" {
            output = .pants
        } else {
            output = .blank
        }
        return output
    }
    
    func userWearsSuchOufit(outfit: [ClothesPref], cloth: ClothesType) -> Bool {
        var isAllowed = true
        let possiblePairings = ["Jacket", "Blazer, Suit Jacket", "Cardigan, Sweater, Tutrtleneck", "Shirt", "T-Shirt, Top", "Leggins", "With nothing"]
        let possibleCLothes: [ClothesType] = [
            .jackets,
            .suitJackets,
            .hoodies,
            .shirts,
            .tshirts,
            .pants
        ]
        var notAllowedClothes: [ClothesType] = []
        var pairings: [String] = []
        
        if cloth == .dresses {
            pairings = user.dressPairings
        } else if cloth == .skirts {
            pairings = user.skirtPairings
        }
        
        for option in possiblePairings {
            if !pairings.contains(option) {
                notAllowedClothes.append(getClothTypeFromPreference(preference: option))
            }
        }
        
        for notAllowedCloth in notAllowedClothes {
            if outfit.contains(where: {$0.type == notAllowedCloth}) {
                isAllowed = false
            }
        }
        return isAllowed
    }
    
    func removeHatFromConfig(config :[StyleOutfits], tempTypes: [String]) -> [StyleOutfits] {
        let type: ClothesType = .headdresses
        var updatedConfig = config
        var excludedTempTypes = ["superCold", "cold", "coldy", "cool", "regular", "warm", "hot"]
        if !tempTypes.isEmpty {
            excludedTempTypes = tempTypes
        }
        
        updatedConfig = config.map { styleOutfit in
            var updatedStyleOutfit = styleOutfit
            updatedStyleOutfit.outfits = styleOutfit.outfits.map { outfit in
                outfit.filter { clothesPref in
                    !(clothesPref.type == type && excludedTempTypes.contains(clothesPref.temp.rawValue))
                }
            }
            return updatedStyleOutfit
        }
        return updatedConfig
    }
    
    func removeTshirtFromConfig(config :[StyleOutfits]) -> [StyleOutfits] {
        let type: ClothesType = .tshirts
        var updatedConfig = config
        
        updatedConfig = config.map { styleOutfit in
            var updatedStyleOutfit = styleOutfit
            updatedStyleOutfit.outfits = styleOutfit.outfits.map { outfit in
                outfit.filter { cloth in
                    !(cloth.type == type && outfit.contains(where: {$0.type == .hoodies}))
                }
            }
            return updatedStyleOutfit
        }
        return updatedConfig
    }
    
    @Published var fittingOutfitsResponse = [FittingOutfitsResponse]()
    @Published var notRealClothesTemps = [NotRealCloth]()
    func getRightOutfits() {
        notRealClothesTemps = []
        fittingOutfitsResponse = []
            for day in days {
                var fittingOutfits: FittingOutfitsResponse
                let config = getConfig(weather: day.weather)
                print("--------DAY--------")
                print(day)
                fittingOutfits = getOutfitsForDay(config: config)
                
                
                let fittingOutfitResponse = FittingOutfitsResponse(id: day.id, outfits: fittingOutfits.outfits, code: fittingOutfits.code, error: fittingOutfits.error)
                fittingOutfitsResponse.append(fittingOutfitResponse)
            }
    }
    
    func getListOfPercentFittingOutfits(clothes: [Cloth], config: [StyleOutfits]) -> [PercentFittingOutfit] {
        var percentFittingOutfits = [PercentFittingOutfit(style: .business, outfit: [], percent: 0)]
        
        for style in config {
            let styleName = style.style
            for list in style.outfits {
                var tempClothes = [Cloth]()
                var absentTypes = [ClothesPref]()
                
                for pref in list {
                    if let fitingCloth = clothes.first(where: {$0.type == pref.type}) {
                        if fitingCloth.temperature.contains(pref.temp.rawValue) {
                            tempClothes.append(fitingCloth)
                        } else {
                            absentTypes.append(pref)
                        }
                    } else {
                        absentTypes.append(pref)
                    }
                }
                
                if tempClothes.count == list.count {
                    if let accessories = clothes.first(where: {$0.type == .accessories}) {
                        tempClothes.append(accessories)
                    }
                    percentFittingOutfits.append(PercentFittingOutfit(style: styleName, outfit: tempClothes, percent: 100))
                } else {
                    let percent = (Double(tempClothes.count) / Double(list.count)) * 100
                    if let accessories = clothes.first(where: {$0.type == .accessories}) {
                        tempClothes.append(accessories)
                    }
                    percentFittingOutfits.append(PercentFittingOutfit(style: styleName, outfit: tempClothes, percent: percent, absentTypes: absentTypes))
                }
            }
        }

        return percentFittingOutfits
    }
    
//    func getOutfitsForDay(config: [StyleOutfits]) -> FittingOutfitsResponse {
//        
//        guard !clothes.isEmpty else {
//            return FittingOutfitsResponse(id: 0, outfits: [], code: 401, error: "No items in wardrobe")
//        }
//        
//        guard !outfits.isEmpty else {
//            return FittingOutfitsResponse(id: 0, outfits: [], code: 402, error: "No outfits")
//        }
////        
//        let usersFittingOutfits = getFittingOutfits(config: config)
//        if !usersFittingOutfits.isEmpty {
//            let notIncludedStyles = notIncludedStyles(allFittingOutfits: usersFittingOutfits)
//            if notIncludedStyles.isEmpty {
//                return FittingOutfitsResponse(id: 0, outfits: sortOutfitsByPreferredStyle(usersFittingOutfits), code: 200, error: "")
//            }
//        }
//        
//        let generatedOutfits = generateOutfits(from: clothes, config: config)
//        return FittingOutfitsResponse(id: 0, outfits: sortOutfitsByPreferredStyle(generatedOutfits), code: generatedOutfits.isEmpty ? 400 : 200, error: generatedOutfits.isEmpty ? "Unable to generate suitable outfits" : "")
//    }
//
//    private func getFittingOutfits(config: [StyleOutfits]) -> [FittingOutfit] {
//        var fittingOutfits = [FittingOutfit]()
//        
//        var outfitId = 0
//        for outfit in outfits {
//            let clothesIds = getClothesByIds(outfit.clothes)
//            let rightOutfits = getListOfPercentFittingOutfits(clothes: clothesIds, config: config)
//            
//            for rightOutfit in rightOutfits where rightOutfit.percent == 100 {
//                let sortedOutfit = sortClothes(clothesList: rightOutfit.outfit)
//                if !sortedOutfit.isEmpty && !fittingOutfits.contains(where: { $0.outfit == sortedOutfit }) {
//                    fittingOutfits.append(FittingOutfit(id: outfitId, style: rightOutfit.style, outfit: sortedOutfit, isGenerated: false))
//                    outfitId += 1
//                }
//            }
//        }
//        
//        return fittingOutfits
//    }
//    
//    private func notIncludedStyles(allFittingOutfits:[FittingOutfit]) -> [OutfitStyle] {
//        var notIncludedStyles: [OutfitStyle] = []
//        for style in OutfitStyle.allCases {
//            if !allFittingOutfits.map({$0.style}).contains(style) {
//                notIncludedStyles.append(style)
//            }
//        }
//        return notIncludedStyles
//    }
//
//    private func generateOutfits(from clothes: [Cloth], config: [StyleOutfits]) -> [FittingOutfit] {
//        let notFittingOutfits = getNotFittingOutfits(clothes: clothes, config: config)
//        let allFittingOutfits = completeOutfits(notFittingOutfits: notFittingOutfits, clothes: clothes)
//        
//        return createFittingOutfits(from: allFittingOutfits)
//    }
//
//    private func getNotFittingOutfits(clothes: [Cloth], config: [StyleOutfits]) -> [PercentFittingOutfit] {
//        // Implementation details...
//    }
//
//    private func completeOutfits(notFittingOutfits: [PercentFittingOutfit], clothes: [Cloth]) -> [PercentFittingOutfit] {
//        // Implementation details...
//    }
//
//    private func createFittingOutfits(from allFittingOutfits: [PercentFittingOutfit]) -> [FittingOutfit] {
//        // Implementation details...
//    }
//
//    private func sortOutfitsByPreferredStyle(_ outfits: [FittingOutfit]) -> [FittingOutfit] {
//        let preferedStyle = user.preferedStyle
//        return outfits.sorted { outfit1, outfit2 in
//            if outfit1.style.rawValue == preferedStyle && outfit2.style.rawValue != preferedStyle {
//                return true
//            } else if outfit1.style.rawValue != preferedStyle && outfit2.style.rawValue == preferedStyle {
//                return false
//            } else {
//                return outfit1.id < outfit2.id
//            }
//        }
//    }
//    
    
    
    func getOutfitsForDay(config: [StyleOutfits]) -> FittingOutfitsResponse {
        var code = 200
        var error = ""
        var fittingOutfits = [FittingOutfit]()
        var notFittingOutfits = [PercentFittingOutfit]()
        
        
        var count = 0
        for outfit in outfits {
            
            let clothesIds = getClothesByIds(outfit.clothes)
            
            let rightOutfits = getListOfPercentFittingOutfits(clothes: clothesIds, config: config)
            
            for outfit in rightOutfits {
                if outfit.percent == 100 {
                    if !outfit.outfit.isEmpty  {
                        let fittingOutfit = FittingOutfit(id: count, style: outfit.style, outfit: sortClothes(clothesList: outfit.outfit), isGenerated: false)
                        if !fittingOutfits.contains(where: { $0.outfit == fittingOutfit.outfit}) {
                            fittingOutfits.append(fittingOutfit)
                            count += 1
                        }
                    }
                } else {
                    if !outfit.outfit.isEmpty  {
                        notFittingOutfits.append(outfit)
                    }
                }
            }
        }
        
        if fittingOutfits.isEmpty {
            var allFittingOutfits = [PercentFittingOutfit]()
            var notRealClothesOutfits = [PercentFittingOutfit]()
            
            notFittingOutfits.sort { $0.percent > $1.percent }
            outerloop: for bestOutfit in notFittingOutfits {
                var changedOutfit = PercentFittingOutfit(style: bestOutfit.style, outfit: bestOutfit.outfit, percent: 0)

                if let absentTypes = bestOutfit.absentTypes {
                    for type in absentTypes {
                        let fittingClothes = clothes.filter { $0.type == type.type && $0.temperature.contains(type.temp.rawValue) }
                        if !fittingClothes.isEmpty {
                            var fittingClothesOutfits = [PercentFittingOutfit]()
                            
                            for cloth in fittingClothes {
                                var newOutfit = changedOutfit.outfit
                                newOutfit.append(cloth)
                                let newOutfitNames = Set(newOutfit.map { $0.id })
                                
                                for userOutfit in outfits {
                                    let set = Set(userOutfit.clothes).intersection(newOutfitNames)

                                    if set.contains(cloth.id) {
                                        let percent = Double(set.count - 1) / Double(newOutfitNames.count) * 100
                                        fittingClothesOutfits.append(PercentFittingOutfit(style: bestOutfit.style, outfit: newOutfit, percent: percent))
                                    } else {
                                        fittingClothesOutfits.append(PercentFittingOutfit(style: bestOutfit.style, outfit: newOutfit, percent: 0))
                                    }
                                }
                            }
                            if !fittingClothesOutfits.isEmpty {
                                fittingClothesOutfits.sort { $0.percent > $1.percent }
                                changedOutfit = fittingClothesOutfits[0]
                                print("changedOutfit", changedOutfit)
                            }
                        } else {
                            error = "No suitable \(type.type.rawValue) for temperatures \(GetTemperatureRange.getTemperatureRange(type: type.temp))"
                            code = 400
                            break
                        }
                    }
                    if changedOutfit.outfit.count == bestOutfit.outfit.count + absentTypes.count {
                        allFittingOutfits.append(changedOutfit)
                    }
                }
            }
            
            let hasBusinessOutfit = allFittingOutfits.map({$0.style}).contains(.business)
            let hasCasualOutfit = allFittingOutfits.map({$0.style}).contains(.casual)
            
            if allFittingOutfits.isEmpty || !hasCasualOutfit || !hasBusinessOutfit {
                print("allFittingOutfits is empty")
                for bestOutfit in notFittingOutfits {
                    if let absentTypes = bestOutfit.absentTypes {
                        let fullOutfitCount = Double(bestOutfit.outfit.count + absentTypes.count)
                        let percent = Double(bestOutfit.outfit.count) / fullOutfitCount * 100
                        if percent >= 0 {
                            var notRealClothesOutfit = PercentFittingOutfit(style: bestOutfit.style, outfit: bestOutfit.outfit, percent: percent)
                            let id = "Not real cloth "
                            var counter = 0
                            for cloth in absentTypes {
                                let newCloth = Cloth(id: id+cloth.type.rawValue+counter.description , name: cloth.type.rawValue, type: cloth.type, color: "#FFFFFF", temperature: [cloth.temp.rawValue] , isDefault: true, image: cloth.type.rawValue, creationDate: 0)
                                notRealClothesOutfit.outfit.append(newCloth)
                                
                                let notRealCloth = NotRealCloth(id: id+cloth.type.rawValue+counter.description, type: cloth.type, temp: cloth.temp)
                                notRealClothesTemps.append(notRealCloth)
                                counter += 1
                            }
                            notRealClothesOutfits.append(notRealClothesOutfit)
                        }
                    }
                }
                
                
                notRealClothesOutfits.sort { $0.percent > $1.percent }
                if let businessOutfit = notRealClothesOutfits.first(where: { $0.style == .business }) {
                    if !hasBusinessOutfit {
                        allFittingOutfits.append(businessOutfit)
                        print("business added")
                    }
                }
                
                
                if let casualOutfit = notRealClothesOutfits.first(where: { $0.style == .casual }) {
                    if !hasCasualOutfit {
                        allFittingOutfits.append(casualOutfit)
                        print("casual added")
                    }
                }
                
            }
            
            allFittingOutfits.sort { $0.percent > $1.percent }
            for bestOutfit in allFittingOutfits {
                let fittingOutfit = FittingOutfit(id: count, style: bestOutfit.style, outfit: sortClothes(clothesList: bestOutfit.outfit), isGenerated: true)
                if !fittingOutfits.contains(where: { $0.outfit == fittingOutfit.outfit}) {
                    fittingOutfits.append(fittingOutfit)
                    
                    count += 1
                    // NOTICE rewrite to check both styles
//                    if bestOutfit.percent == 0 || count >= 2 {
//                        break
//                    }
//                    if fittingOutfits.filter({$0.style == .business}).count > 1 && fittingOutfits.count > 2 || fittingOutfits.filter({$0.style == .casual}).count > 1 && fittingOutfits.count > 2 { break }
                }
            }
        }
                
        if clothes.isEmpty {
            error = "No items in wardrobe"
            code = 401
        } else if outfits.isEmpty {
            error = "No outfits"
            code = 402
        }
        
        //sort outfits depending on user prefered style
        let preferedStyle = user.preferedStyle
        fittingOutfits.sort { outfit1, outfit2 in
            if outfit1.style.rawValue == preferedStyle && outfit2.style.rawValue != preferedStyle {
                return true
            } else if outfit1.style.rawValue != preferedStyle && outfit2.style.rawValue == preferedStyle {
                return false
            } else {
                return outfit1.id < outfit2.id
            }
        }
        
        return  FittingOutfitsResponse(id: 0, outfits: fittingOutfits, code: fittingOutfits.isEmpty ? code : 200, error: fittingOutfits.isEmpty ? error : "")
    }
    
    func sortClothes(clothesList: [Cloth]) -> [Cloth] {
        let clothes = CreateDefaultWardrobe.getClothes()
        var sortedClothes: [Cloth] = []
        for clothesType in clothes {
            if let index = clothesList.firstIndex(where: {$0.type == clothesType.clothesTypeName} ) {
                sortedClothes.append(clothesList[index])
            }
        }
        return sortedClothes
    }
    
    
    
    //Clear ViewModel
    func clearViewModel() {
        weather = ResponseBodyForecastAPI(cod: "100", message: 0, cnt: 0, list: [], city: CityResponse(id: 0, name: "", country: "", population: 0, timezone: 0, sunrise: 0, sunset: 0))
        chosenWeather = Weather(code: 100, name: "Clouds", color: "#B1B4B8", icon: "cloud", temp: 0, humidity: 99, windSpeed: 2)
        selectedId = 0
        days = []
        
        stateCityName = .placeholder
        geonamesResponse = GeonamesResponse(totalResultsCount: 0, geonames: [])
        cityNames = []
        
        userIsLoggedIn = false
        userEmail = ""
        userPassword = ""
        showSecondPage = false
        userId = ""
        
        user = User(id: "", username: "", userIcon: "", config: "", didOnboarding: false, preferedStyle: "", hatTemperature: "", isTshirtUnder: true, excludedClothes: [], skirtPairings: [], skirtWeather: [], dressPairings: [], dressWeather: [])
        clothes = []
        wardrobe = []
        wardrobeState = .placeholder
        
        outfits = []
        outfitState = .placeholder
        
        fittingOutfitsResponse = []
        notRealClothesTemps = []
    }
    
    //Deprecated
    
//    @Published var clothes: [Wardrobe] = []
//    @Published var outfits: [Outfit] = [Outfit(id: 0, outfit: [], isGenerated: false)]
//
//    func getOutfits() {
//        let resultOutfits = GetOutfits.getOutfits()
//        outfits = resultOutfits
//    }
//
//    func getClothes() {
//        let resultClothes = GetClothes.getClothes()
//        clothes = resultClothes
//    }
}
