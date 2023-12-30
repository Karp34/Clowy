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
import FirebaseRemoteConfig
import Kingfisher

class MainScreenViewModel: ObservableObject {
    static var shared = MainScreenViewModel()
    
    @Published var state: PlaceHolderState = .placeholder
    @Published var stateCityName: PlaceHolderState = .placeholder
    
    @Published var weather = ResponseBodyForecastAPI(cod: "100", message: 0, cnt: 0, list: [], city: CityResponse(id: 0, name: "", country: "", population: 0, timezone: 0, sunrise: 0, sunset: 0))
    
    @Published var cityNames = [String]()
    
    @Published var chosenWeather: Weather = Weather(code: 100, name: "Default", color: "#B1B4B8", icon: "cloud", temp: 20, humidity: 99, windSpeed: 2)
    @Published var selectedId: Int = 0
    @Published var days: [Day] = []
    
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
//                print(data.list[item])
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
//                        print(name)
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
    @Published var coordinates: (lat: Double, lon: Double)? = nil
    @Published var coordinatesReceived: Bool = false
    
    func getCoordinates() {
        observeCoordinateUpdates()
        observeDeniedLocationAccess()
    }
    
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
                self.coordinatesReceived = true
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
    @Published var userId: String = ""
    
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
    
    func getUserId() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        userId = userID
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
                    
                    let cloth = Cloth(id: id, name: name, type: ClothesType(rawValue: type) ?? ClothesType.blank, color: color, temperature: temperature, isDefault: isDefault, image: image)
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
                    var items: [Cloth] = []
                    for cloth in self.clothes {
                        if cloth.type == type {
                            items.append(cloth)
                        }
                    }
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
                    clothes.append(Cloth(id: "1100", name: "", type: .tshirts, color: "#000000", temperature: ["Cold"], isDefault: true, image: "DefaultUpperWear"))

                case "1101":
                    clothes.append(Cloth(id: "1101", name: "", type: .pants, color: "#000000", temperature: ["Cold"], isDefault: true, image: "DefaultPants"))
                    
                case "1102":
                    clothes.append(Cloth(id: "1102", name: "", type: .sneakers, color: "#00000", temperature: ["Cold"], isDefault: true, image: "DefaultSneaker"))
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
    
    func deleteCloth(clothId: String, imageId: String) {
//      thnik how to delete from each outfit and delete from storage
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(userId).collection("Wardrobe").document(clothId)
        ref.delete { error in
            if error == nil {
                self.fetchWardrobe() {}
                self.deleteFromStorage(clothId: imageId)
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
              print("Success")
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
    
    func getConfig(weather: Weather) -> [[ClothesPref]] {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try! encoder.encode(outfitConfig)

        
        let temp = Double(weather.temp) + (( UserDefaults.standard.double(forKey: "prefTemp") - 0.5 ) * -10 )
        var config = [[ClothesPref]]()
        var configs: OutfitConfig
        
        if temp <= -20 {
            configs = outfitConfig.first(where: {$0.name == "SuperCold"})!
        } else if temp <= -10 && temp > -20 {
            configs = outfitConfig.first(where: {$0.name == "Cold"})!
        } else if temp <= 0 && temp > -10 {
            configs = outfitConfig.first(where: {$0.name == "Coldy"})!
        } else if temp <= 10 && temp > 0 {
            configs = outfitConfig.first(where: {$0.name == "Regular"})!
        } else if temp <= 20 && temp > 10 {
            configs = outfitConfig.first(where: {$0.name == "Warm"})!
        } else {
            configs = outfitConfig.first(where: {$0.name == "Hot"})!
        }
        
        if weather.code.description.hasPrefix("2") || weather.code.description.hasPrefix("5") || weather.code.description.hasPrefix("6") || weather.windSpeed > 15  {
            config = configs.weatherConfig.first(where: {$0.weather == .rain})!.clothes
        } else if weather.humidity > 65 {
            config = configs.weatherConfig.first(where: {$0.weather == .humidity})!.clothes
        } else if weather.code == 804 {
            config = configs.weatherConfig.first(where: {$0.weather == .lightRain})!.clothes
        } else {
            config = configs.weatherConfig.first(where: {$0.weather == .sunny})!.clothes
        }
                    
        return config
    }
    
    @Published var fittingOutfitsResponse = [FittingOutfitsResponse]()
    func getRightOutfits() {
        fittingOutfitsResponse = []
//        if !self.wardrobe.isEmpty && !self.clothes.isEmpty && !self.days.isEmpty {
            for day in days {
                var fittingOutfits: FittingOutfitsResponse
                let config = getConfig(weather: day.weather)
//                print(config)
                fittingOutfits = getOutfitsForDay(config: config)
                
                
                let fittingOutfitResponse = FittingOutfitsResponse(id: day.id, outfits: fittingOutfits.outfits, code: fittingOutfits.code, error: fittingOutfits.error)
//                print("______________")
//                print(day.name)
//                print("FITTING OUTFITS \(fittingOutfitResponse)")
                fittingOutfitsResponse.append(fittingOutfitResponse)
//                print("")
//                print("")
            }
           
//        } else {
//            print("Error something is missing")
//        }
    }
    
    func getRightOutfit(clothes: [Cloth], config: [[ClothesPref]]) -> [PercentFittingOutfit] {
        var percentFittingOutfits = [PercentFittingOutfit(outfit: [], percent: 0)]
        
        for list in config {
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
                percentFittingOutfits.append(PercentFittingOutfit(outfit: tempClothes, percent: 100))
            } else {
                let percent = (Double(tempClothes.count) / Double(list.count)) * 100
                if let accessories = clothes.first(where: {$0.type == .accessories}) {
                    tempClothes.append(accessories)
                }
                percentFittingOutfits.append(PercentFittingOutfit(outfit: tempClothes, percent: percent, absentTypes: absentTypes))
            }
        }
        
        return percentFittingOutfits
    }
    
    
    
    func getOutfitsForDay(config: [[ClothesPref]]) -> FittingOutfitsResponse {
        var code = 200
        var error = ""
        var fittingOutfits = [FittingOutfit]()
        var notFittingOutfits = [PercentFittingOutfit]()
        
        
        var count = 0
        for outfit in outfits {
            
            let clothes = getClothesByIds(outfit.clothes)
            let rightOutfits = getRightOutfit(clothes: clothes, config: config)
            
            for outfit in rightOutfits {
                if outfit.percent == 100 {
                    if !outfit.outfit.isEmpty  {
                        let fittingOutfit = FittingOutfit(id: count, outfit: outfit.outfit, isGenerated: false)
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
            
            notFittingOutfits.sort { $0.percent > $1.percent }
            outerloop: for outfit in notFittingOutfits {
//                var changedOutfit = outfit.outfit
                var changedOutfit = PercentFittingOutfit(outfit: outfit.outfit, percent: 0)
//                var addedItemsCount = 0
                if let absentTypes = outfit.absentTypes {
                    for type in absentTypes {
//                        print(type.type.rawValue)
                        let fittingClothes = clothes.filter { $0.type == type.type && $0.temperature.contains(type.temp.rawValue) }
                        if !fittingClothes.isEmpty {
//                            print("clothes exist")
                            var fittingClothesOutfits = [PercentFittingOutfit]()
                            
                            for cloth in fittingClothes {
                                var newOutfit = changedOutfit.outfit
                                newOutfit.append(cloth)
                                let newOutfitNames = Set(newOutfit.map { $0.id })
                                
                                for outfit in outfits {
                                    let set = Set(outfit.clothes).intersection(newOutfitNames)
//                                    print(set)
//                                    print(set.count)
//                                    print(newOutfitNames.count)
                                    if set.contains(cloth.id) {
                                        let percent = Double(set.count - 1) / Double(newOutfitNames.count) * 100
                                        fittingClothesOutfits.append(PercentFittingOutfit(outfit: newOutfit, percent: percent))
//                                        print("\(cloth.name)")
//                                        print("appended to fittingClothesOutfits")
                                    } else {
                                        fittingClothesOutfits.append(PercentFittingOutfit(outfit: newOutfit, percent: 0))
//                                        print("\(cloth.name)")
//                                        print("appended to fittingClothesOutfits with 0 percent")
                                    }
                                }
                            }
                            if !fittingClothesOutfits.isEmpty {
                                fittingClothesOutfits.sort { $0.percent > $1.percent }
                                changedOutfit = fittingClothesOutfits[0]
//                                print("New changed outfit")
//                                print(changedOutfit)
                                
                            }
                        } else {
                            error = "No suitable \(type.type.rawValue) for temperatures \(GetTemperatureRange.getTemperatureRange(type: type.temp))"
                            code = 400
                            break
                        }
                    }
                    if changedOutfit.outfit.count == outfit.outfit.count + absentTypes.count {
                        allFittingOutfits.append(changedOutfit)
//                        print("appended to allFittingOutfits")
//                        print(allFittingOutfits)
                    }
                }
            }
            allFittingOutfits.sort { $0.percent > $1.percent }
            for bestOutfit in allFittingOutfits {
                let fittingOutfit = FittingOutfit(id: count, outfit: sortClothes(clothesList: bestOutfit.outfit), isGenerated: true)
                if !fittingOutfits.contains(where: { $0.outfit == fittingOutfit.outfit}) {
                    fittingOutfits.append(fittingOutfit)
//                    print("appended to fittingOutfits")
//                    print(fittingOutfits)
                    count += 1
                    if bestOutfit.percent == 0 || count >= 2 {
                        break
                    }
                }
            }
        }
                
                    
                    
                                
                                
                                
//                                    if set.count > 1 && set.contains(cloth.id) {
//                                        changedOutfit.append(cloth)
//                                        break
//                                    }
//                                }
//                                if changedOutfit.count > outfit.outfit.count + addedItemsCount {
//                                    addedItemsCount += 1
//                                    break
//                                }
//                            }
//
//                            if changedOutfit.count == outfit.outfit.count + absentTypes.count {
//                                count += 1
//                                if count > 2 {
//                                    break outerloop
//                                }
//                                let fittingOutfit = FittingOutfit(id: count, outfit: sortClothes(clothesList: changedOutfit), isGenerated: true)
//                                if !fittingOutfits.contains(where: { $0.outfit == fittingOutfit.outfit}) {
//                                    fittingOutfits.append(fittingOutfit)
//                                }
//                            }
                                    
//                        } else {
//                            error = "No suitable \(type.type.rawValue) for temperatures \(GetTemperatureRange.getTemperatureRange(type: type.temp))"
//                            code = 400
//                            break
//                        }
//                    }
//                }
//            }
//        }
        
        
        if clothes.isEmpty {
            error = "No items in wardrobe"
            code = 401
        } else if outfits.isEmpty {
            error = "No outfits"
            code = 402
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
    
    
    //Remote Config
    remoteConfig = RemoteConfig.remoteConfig()

    let settings = RemoteConfigSettings()
    settings.minimumFetchInterval = 0
    remoteConfig.configSettings = settings

    remoteConfig.setDefaults(fromPlist: "RemoteConfigDefaults")
    
    
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
