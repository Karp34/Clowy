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
    @Published var state: PlaceHolderState = .placeholder
    @Published var weather = ResponseBodyWeatherAPI(coord: CoordinatesResponse(lon: 0, lat: 0), weather: [WeatherResponse(id: 0, main: "sunny", description: "sunny", icon: "sunny")], base: "aa", main: MainResponse(temp: 0, feels_like: 0, temp_min: 0, temp_max: 0, pressure: 0, humidity: 0, sea_level: 0, grnd_level: 0), wind: WindResponse(speed: 0, deg: 0, gust: 0), clouds: CloudsResponse(all: 99), dt: 0, sys: SysResponse(type: 0, id: 0, country: "Russia", sunrise: 0, sunset: 0), timezone: 0, id: 0, name: "", cod: 200)
        
    func getWeatherData(parameters: [String : String]) {
        guard let lat = parameters["lat"],
              let long = parameters["long"],
              let appID = parameters["appid"] else { print("Invalid parameters"); return }
        var urlComponents = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
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
                    self.weather = try decoder.decode(ResponseBodyWeatherAPI.self, from: data)
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

struct ResponseBodyWeatherAPI: Codable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var base: String
    var main: MainResponse?
    var wind: WindResponse
    var clouds: CloudsResponse
    var dt: Int
    var sys: SysResponse
    var timezone: Int
    var id: Double
    var name: String
    var cod: Double
    
}
    
struct CoordinatesResponse: Codable {
    var lon: Double
    var lat: Double
}

struct WeatherResponse: Codable, Identifiable {
    var id: Double
    var main: String
    var description: String
    var icon: String
}

struct CloudsResponse: Codable {
    var all: Double
}

struct SysResponse: Codable {
    var type: Double?
    var id: Int?
    var country: String?
    var sunrise: Double
    var sunset: Double
}

struct MainResponse: Codable {
    var temp: Double
    var feels_like: Double?
    var temp_min: Double?
    var temp_max: Double?
    var pressure: Double
    var humidity: Double
    var sea_level: Double?
    var grnd_level: Double?
}

struct WindResponse: Codable {
    var speed: Double
    var deg: Double
    var gust: Double
}

struct LocationTestView: View {
    @ObservedObject var viewModel = LocationTestViewModel()
    
    @StateObject var deviceLocationService = DeviceLocationService.shared

    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0, 0)
    
    
    var body: some View {
        VStack {
            VStack {
                if viewModel.state == .placeholder {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.blue)
                        .frame(width: 180, height: 14)
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.blue)
                        .frame(width: 200, height: 14)
                    RoundedRectangle(cornerRadius: 14)
                        .foregroundColor(.blue)
                        .frame(width: 100, height: 16)
                    
                }
                if viewModel.state == .error {
                    Text("Error has occured")
                }
                if viewModel.state == .success {
                    Text("Latitude: \(coordinates.lat)")
        //                .font(.largeTitle)
                    Text("Longitude: \(coordinates.lon)")
                    Text(viewModel.weather.name)
                }
            }
            .frame(height: 200)
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
            
            NavigationLink {
                ChooseLocationView()
            } label: {
                Text("Geo")
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
