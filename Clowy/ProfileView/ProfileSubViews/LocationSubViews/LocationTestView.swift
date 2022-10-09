//
//  LocationTestView.swift
//  Clowy
//
//  Created by Егор Карпухин on 24.08.2022.
//

import Combine
import SwiftUI
import CoreLocation



class LocationTestViewModel: ObservableObject {
    static var shared = LocationTestViewModel()
    
    @Published var state: PlaceHolderState = .placeholder
    @Published var stateCityName: PlaceHolderState = .placeholder
//    @Published var weather = ResponseBodyWeatherAPI(coord: CoordinatesResponse(lon: 0, lat: 0), weather: [WeatherResponse(id: 0, main: "sunny", description: "sunny", icon: "sunny")], base: "aa", main: MainResponse(temp: 0, feels_like: 0, temp_min: 0, temp_max: 0, pressure: 0, humidity: 0, sea_level: 0, grnd_level: 0), wind: WindResponse(speed: 0, deg: 0, gust: 0), clouds: CloudsResponse(all: 99), dt: 0, sys: SysResponse(type: 0, id: 0, country: "Russia", sunrise: 0, sunset: 0), timezone: 0, id: 0, name: "", cod: 200)
    
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
}
    
//    func loadData(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> ResponseBodyWeatherAPI{
//        let request = URLRequest(
//            url: URL(string: "https://api.openweathermap.org/data/2.5/forecast?appid=b2974b730a41c731572b6e8b3ba9327d&lat=\(latitude)&lon=\(longitude)&units=metric")!,
//            timeoutInterval: Double.infinity
//        )
//
//        var weather = ResponseBodyWeatherAPI(coord: CoordinatesResponse(lon: 0, lat: 0), weather: [WeatherResponse(id: 0, main: "sunny", descriprion: "sunny", icon: "sunny")], base: "aa", main: MainResponse(temp: 0, feels_like: 0, temp_min: 0, temp_max: 0, pressure: 0, humidity: 0, sea_level: 0, grnd_level: 0), wind: WindResponse(speed: 0, deg: 0, gust: 0), clouds: CloudsResponse(all: 99), dt: 0, sys: SysResponse(type: 0, id: 0, country: "Russia", sunrise: 0, sunset: 0), timezone: 0, id: 0, name: "aaa", cod: 200)
//
//        URLSession.shared.dataTask(with: request) { (data, res, error) in
//            do {
//                if let data = data {
//                    print("1")
//                    let result = try JSONDecoder().decode(ResponseBodyWeatherAPI.self, from: data)
//                    print(result)
//                    DispatchQueue.main.async {
//                        weather = result
//                    }
//                    print(result)
//                    print("3")
//                } else {
//                    print(String(describing: error))
//                    print("4")
//                }
//            }
//            catch (let error) {
//                print(String(describing: error))
//                print("5")
//            }
//        }.resume()
//
//        return weather
//    }



struct LocationTestView: View {
//    @ObservedObject var viewModel = LocationTestViewModel()
    @StateObject private var viewModel = LocationTestViewModel.shared
    
    @StateObject var deviceLocationService = DeviceLocationService.shared

    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0, 0)
    @State var showSheet = false
    @State var showSheet2 = false
    
    @State var timeNow = "60"
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
            var dateFormatter: DateFormatter {
                    let fmtr = DateFormatter()
                    fmtr.dateFormat = "S"
                    return fmtr
            }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                
                if viewModel.state == .error {
                    Text("Error has occured")
                }
                if viewModel.state == .success {
                    Text("Latitude: \(coordinates.lat)")
        //                .font(.largeTitle)
                    Text("Longitude: \(coordinates.lon)")
                    Text(viewModel.weather.city.name)
                    
//                    VStack(alignment: .leading) {
                    HStack {
//                        ForEach (0..<16) { item in
//                            let weatherList = viewModel.weather.list[item]
                            HStack {
                                VStack(alignment: .leading) {
                                    ForEach (0..<16) { item in
                                        let weatherList = viewModel.weather.list[item]
                                        Text(weatherList.dt_txt)
                                    }
                                }
                                VStack(alignment: .leading) {
                                    ForEach (0..<16) { item in
                                        let weatherList = viewModel.weather.list[item]
                                        Text(String(weatherList.main.temp))
                                    }
                                }
                                VStack(alignment: .leading) {
                                    ForEach (0..<16) { item in
                                        let weatherList = viewModel.weather.list[item]
                                        Text(weatherList.weather[0].main)
                                    }
                                }
                                VStack(alignment: .leading) {
                                    ForEach (0..<16) { item in
                                        let weatherList = viewModel.weather.list[item]
                                        Text(String(weatherList.wind.speed))
                                    }
                                }
                                VStack(alignment: .leading) {
                                    ForEach (0..<16) { item in
                                        let weatherList = viewModel.weather.list[item]
                                        Text(String(weatherList.main.humidity))
                                    }
                                }
                            }
                        }
//                    }
                }
            }
//            .frame(height: 200)

            HStack {
                Button {
                    withAnimation {
                        viewModel.state = .error
                    }
                } label: {
                    Text("Error")
                }
                Button {
                    withAnimation {
                        viewModel.state = .placeholder
                    }
                } label: {
                    Text("Placeholder")
                }
                Button {
                    viewModel.getWeatherData(parameters: ["lat": "55.75396", "long": "37.62039", "appid": "b2974b730a41c731572b6e8b3ba9327d"])
                } label: {
                    Text("Get data")
                }
            }
//
//            VStack {
//                if viewModel.stateCityName == .placeholder {
//                    RoundedRectangle(cornerRadius: 16)
//                        .foregroundColor(.blue)
//                        .frame(width: 180, height: 14)
//                    RoundedRectangle(cornerRadius: 16)
//                        .foregroundColor(.blue)
//                        .frame(width: 200, height: 14)
//                    RoundedRectangle(cornerRadius: 14)
//                        .foregroundColor(.blue)
//                        .frame(width: 100, height: 16)
//
//                }
//                if viewModel.stateCityName == .error {
//                    Text("Error has occured")
//                }
//                if viewModel.stateCityName == .success {
//                    if viewModel.cityNames.count > 0 {
//                        Text(viewModel.cityNames[0])
//                    }
//                }
//            }
//            .frame(height: 200)
//
//            HStack {
//                Button {
//                    withAnimation {
//                        viewModel.stateCityName = .error
//                    }
//                } label: {
//                    Text("Error")
//                }
//                Button {
//                    withAnimation {
//                        viewModel.stateCityName = .placeholder
//                    }
//                } label: {
//                    Text("Placeholder")
//                }
//                Button {
//                    viewModel.getCityName(prefixName: "Mos")
//                } label: {
//                    Text("Get data")
//                }
//            }
//
//            NavigationLink {
//                ChooseLocationView()
//            } label: {
//                Text("Geo")
//            }
//
            Button {
                showSheet.toggle()
            } label: {
                Text("Sheet")
            }
            .sheet(isPresented: $showSheet) {
                ChooseLocationView()
            }
            
            Button {
                showSheet.toggle()
            } label: {
                Text("LocationView")
            }
            .sheet(isPresented: $showSheet2) {
                NewLocationView()
            }


            
//                .font(.largeTitle)
//            Text(viewModel.loadData(latitude: 37, longitude: -122).weather.name ?? "aaa")
//            ForEach(0..<(viewModel.weather.weather?.count) { id in
//                Text(id.main)
//            }
            
        }
        .onAppear {
            observeCoordinateUpdates()
            observeDeniedLocationAccess()
            deviceLocationService.requestLocationUpdates()
            
//            print("AAA")
//            print(deviceLocationService.coordinatesPublisher)
//            print("")
        }
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
    
}
