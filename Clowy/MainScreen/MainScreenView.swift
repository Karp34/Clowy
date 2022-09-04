//
//  ContentView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 14.04.2022.
//

import SwiftUI
import Foundation
import AVFAudio
import Combine

class MainScreenViewModel: ObservableObject {
    static var shared = MainScreenViewModel()
    
    @Published var state: PlaceHolderState = .placeholder
    @Published var stateCityName: PlaceHolderState = .placeholder
    
    @Published var weather = ResponseBodyForecastAPI(cod: "200", message: 0, cnt: 0, list: [], city: CityResponse(id: 0, name: "", country: "", population: 0, timezone: 0, sunrise: 0, sunset: 0))
    
    @Published var cityNames = [String]()
        
    func getWeatherData(parameters: [String : String]) {
        guard let lat = parameters["lat"],
              let long = parameters["long"],
              let appID = parameters["appid"] else { print("Invalid parameters"); return }
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")!
        let queryItems = [URLQueryItem(name: "lat", value: lat),
                          URLQueryItem(name: "lon", value: long),
                          URLQueryItem(name: "appid", value: appID),
                          URLQueryItem(name: "units", value: "metric")]
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return }
        URLSession.shared.dataTask(with: url) { ( data, response, err ) in
            DispatchQueue.main.async { // never, never, never sync !!
                if let err = err {
                    print("Failed to get data from url:", err)
                    withAnimation {
                        self.state = .error
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
                } catch {
                    withAnimation {
                        self.state = .error
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
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
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
                        }
                        withAnimation {
                            self.stateCityName = .success
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
    
    func getIconAndColor(statusCode: Double) -> [String] {
        var list = [String]()
        if String(statusCode).hasPrefix("2") {
            list = ["cloud.bolt.fill", "#646C75"]
        }
        else if String(statusCode).hasPrefix("3") || String(statusCode).hasPrefix("5") {
            list =  ["cloud.drizzle.fill", "#646C75"]
        }
        else if String(statusCode).hasPrefix("6") {
            list =  ["cloud.snow.fill", "#646C75"]
        }
        else if String(statusCode).hasPrefix("7") {
            list =  ["smoke.fill", "#646C75"]
        }
        else if String(statusCode).hasPrefix("8") {
            if statusCode == 800 {
                list =  ["sun.max.fill", "#42AAFF"]
            } else {
                list =  ["cloud.fill", "#646C75"]
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
        
        for item in nextDayTempList {
            tempTemp += item.weather.temp
            tempHumidity += item.weather.humidity
            tempWindSpeed += item.weather.windSpeed
            
            icons.append(item.weather.icon)
            colors.append(item.weather.color)
            weatherList2.append(item.weather.name)
        }
        
        let endTemp = tempTemp / nextDayTempList.count
        let endHumidity = tempHumidity / nextDayTempList.count
        let endWindSpeed = tempWindSpeed / nextDayTempList.count
        

        let countedSetWeather = NSCountedSet(array: weatherList2)
        let endWeather = countedSetWeather.max { countedSetWeather.count(for: $0) < countedSetWeather.count(for: $1) }
        
        let position = weatherList2.firstIndex(of: endWeather as! String)
        let endColor = colors[position!]
        let endIcon = icons[position!]
        
        let firstDay = Day(id: days.count, name: endName, weather: Weather(name: endWeather as! String, color: endColor, icon: endIcon, temp: endTemp, humidity: endHumidity, windSpeed: endWindSpeed))
        return firstDay
    }
    
    func parseWeatherData(data: ResponseBodyForecastAPI) -> [Day] {
        var days = [Day]()
        
        if data.cod == "200" {
            let firstFullDate = data.list[0].dt_txt.components(separatedBy: " ")
            let firstDay = (firstFullDate[0].components(separatedBy: "-")[2] as NSString).integerValue
            var tempListResponse = [Day]()
            var nextDayTempList = [Day]()
            var weatherList = [String]()
            
            for item in (0..<data.list.count) {
                let id = item
                let newFullDate = data.list[item].dt_txt.components(separatedBy: " ")
                
                let weather = data.list[item].weather[0].main
                let temp = data.list[item].main.temp_min
                let humidity = data.list[item].main.humidity
                let iconAndColor = getIconAndColor(statusCode: data.list[item].weather[0].id)
                let windSpeed = data.list[item].wind.speed
                
                if firstFullDate[0] == newFullDate[0] {
                    if item == 0 {
                        let name = "Now"
                        let day = Day(id: id, name: name, weather: Weather(name: weather, color: iconAndColor[1], icon: iconAndColor[0], temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed)))
                        
                        days.append(day)
                    } else {
                        let hour = newFullDate[1].components(separatedBy: ":")[0]
                        let intHour = (hour as NSString).integerValue
                        let name = getTimeName(hour: intHour)
                        
                        weatherList.append(weather)
                        
                        if tempListResponse.isEmpty || tempListResponse.contains(where: {$0.name == name}) {
                            let tempDay = Day(id: id, name: name, weather: Weather(name: weather, color: iconAndColor[1], icon: iconAndColor[0], temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed)))
                            tempListResponse.append(tempDay)
                        } else {
                            let firstDay = getAllDayWeather(nextDayTempList: tempListResponse, weatherList: weatherList, days: days)
                            days.append(firstDay)
                            
                            tempListResponse.removeAll()
                            weatherList.removeAll()
                            let secondDay = Day(id: days.count, name: name, weather: Weather(name: weather, color: iconAndColor[1], icon: iconAndColor[0], temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed)))
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
                        let dayInt = newDay - firstDay
                        
                        
                        weatherList.append(weather)
                        
                        let name = (dayInt < 0 || dayInt == 1) ? "Tomorrow" : getDayName(dayInt: dayInt)
                        
                        if nextDayTempList.isEmpty || nextDayTempList.contains(where: {$0.name == name}) {
                            let tempDay = Day(id: id, name: name, weather: Weather(name: weather, color: iconAndColor[1], icon: iconAndColor[0], temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed)))
                            nextDayTempList.append(tempDay)
                            print("added")
                            print(tempDay)
                            print(nextDayTempList)
                            
                        } else {
                            let firstDay = getAllDayWeather(nextDayTempList: nextDayTempList, weatherList: weatherList, days: days)
                            days.append(firstDay)
                            
                            nextDayTempList.removeAll()
                            weatherList.removeAll()
                            let secondDay = Day(id: days.count, name: name, weather: Weather(name: weather, color: iconAndColor[1], icon: iconAndColor[0], temp: Int(temp), humidity: Int(humidity), windSpeed: Int(windSpeed)))
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
        return days
    }
    
    
    @Published var deviceLocationService = DeviceLocationService.shared
    @Published var tokens: Set<AnyCancellable> = []
    @Published var coordinates: (lat: Double, lon: Double) = (0, 0)
    
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
}
    

struct MainScreenView: View, DaysForecastViewDelegate {

    @StateObject private var viewModel = MainScreenViewModel.shared
    @Environment(\.managedObjectContext) var managedObjectContext
    
    
    @State var chosenWeather: Weather = Weather(name: "Cloudy", color: "#cc0000", icon: "cloud", temp: 20, humidity: 99, windSpeed: 2)
    @State var selectedId: Int = 0
    @State var days: [Day] = []
    @State var clothes: [Wardrobe] = []
    @State var outfits: [Outfit] = [Outfit(id: 0, outfit: [], isGenerated: false)]
    
    @State var offset: CGPoint = .zero
    
    
    let defaultOutfit = [
            Cloth(id: 1100, name: "", clothesType: .tshirts, image: "DefaultUpperWear"),
            Cloth(id: 1101, name: "", clothesType: .pants, image: "DefaultPants"),
            Cloth(id: 1102, name: "", clothesType: .sneakers, image: "DefaultSneaker")
        ]
    
    private func changeWeather(id:Int) {
        selectedId = id
        chosenWeather = days.first(where: { $0.id == id })?.weather ?? Weather(name: "Cloudy", color: "#cc0000", icon: "cloud", temp: 666, humidity: 99, windSpeed: 2)
    }
    
    private func getOutfits() {
        let resultOutfits = GetOutfits.getOutfits()
        outfits = resultOutfits
    }
    
    private func getClothes() {
        let resultClothes = GetClothes.getClothes()
        clothes = resultClothes
    }
    
    
    @FetchRequest(
        entity: TestCloth.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TestCloth.name, ascending: true)]
    ) var items: FetchedResults<TestCloth>
    
    @FetchRequest(
        entity: TestWardrobe.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TestWardrobe.id, ascending: true)]
    ) var categories: FetchedResults<TestWardrobe>

    private func createWardrobe(wardrobe: [Wardrobe]) {
        if UserDefaults.standard.bool(forKey: "launchedBefore") == false {
            for clothesType in wardrobe {
                let category = TestWardrobe(context: managedObjectContext)
                category.name = clothesType.clothesTypeName.rawValue
                category.id = Int16(clothesType.id.rawValue)
                PersistenceController.shared.save()
            }
            UserDefaults.standard.set(0.5, forKey: "prefTemp")
            UserDefaults.standard.set("Username", forKey: "username")
            UserDefaults.standard.set("female", forKey: "gender")
            UserDefaults.standard.set("Panda", forKey: "avatar")
            UserDefaults.standard.set("New York", forKey: "location")
            UserDefaults.standard.set(false, forKey: "isGeoposition")
            UserDefaults.standard.set(["London", "New York", "Tokyo", "Paris", "Berlin"], forKey: "locationHistory")


            
            let chosenClothesList = GetChosenClothes.getChosenClothes()
            UserDefaults.standard.set(
                UserDefaults.standard.string(forKey: "gender") == "male" ? chosenClothesList[0].clothes : chosenClothesList[1].clothes, forKey: "chosenClothesTypes")
        }
        
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                    NavigationLink(
                        destination: ProfileView()
                            .navigationBarHidden(true)
                    ) {
                        GreetingView(color: chosenWeather.color)
                            .padding()
                        
                    }
                    
                    WeatherForecastView(
                        name: chosenWeather.name,
                        color: chosenWeather.color,
                        temp: chosenWeather.temp,
                        icon: chosenWeather.icon)
                    .padding(.horizontal)
                    .onTapGesture {
                        DispatchQueue.main.async {
                            viewModel.getWeatherData(parameters: ["lat": "55.75396", "long": "37.62039", "appid": "b2974b730a41c731572b6e8b3ba9327d"])
                        }
                        if viewModel.weather.list.count > 0 {
//                            print(">0")
                            days = viewModel.parseWeatherData(data: viewModel.weather)
                        }
                    }
                    WardrobeModuleView(color: chosenWeather.color)
                        .padding(.horizontal)
                        .padding(.bottom, 32)
                    
                    Section {
                        ClothesCardsView(outfit: outfits.first(where: { $0.id == selectedId })?.outfit ?? [])
                            .padding(.horizontal)
                        
                        AddGeneratedOutfit(isGenerated: outfits.first(where: { $0.id == selectedId })?.isGenerated ?? false, outfit: outfits.first(where: { $0.id == selectedId })?.outfit ?? defaultOutfit)
                    } header: {
                        DaysForecastView(
                            delegate: self,
                            days: days,
                            selectedId: selectedId)
                        .background((offset.y > 380 ? Color(hex: "#F7F8FA") : Color(.clear)).frame(height: 95).edgesIgnoringSafeArea(.all).offset(y: -30))
                    }
                }
                .readingScrollView(from: "scroll", into: $offset)
                
            }
            .coordinateSpace(name: "scroll")
            .onAppear {
                DispatchQueue.main.async {
                    viewModel.getWeatherData(parameters: ["lat": "55.75396", "long": "37.62039", "appid": "b2974b730a41c731572b6e8b3ba9327d"])
                }
                if viewModel.weather.list.count > 0 {
                    print(">0")
                    days = viewModel.parseWeatherData(data: viewModel.weather)
                }
                getOutfits()
                getClothes()
                createWardrobe(wardrobe: clothes)
                UIApplication.shared.setStatusBarStyle(.darkContent, animated: false)
                
                viewModel.observeCoordinateUpdates()
                viewModel.observeDeniedLocationAccess()
                viewModel.deviceLocationService.requestLocationUpdates()
            }
            .navigationBarHidden(true)
            .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
        }
    }
    
    func dayIsChanged(id: Int) {
        changeWeather(id: id)
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainScreenView()
                .previewDevice("iPhone 12 mini")
        }
    }
}
