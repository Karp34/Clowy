//
//  ChooseLocationView.swift
//  Clowy
//
//  Created by Егор Карпухин on 01.09.2022.
//

import SwiftUI

struct ChooseLocationView: View {
    @StateObject private var viewModel = MainScreenViewModel.shared
    
    @State var location = ""
    @State var isChangingLocation = false
    @State var chosenLocation = UserDefaults.standard.string(forKey: "location")
    @State var isGeoposition = UserDefaults.standard.bool(forKey: "isGeoposition")
    @State var locationHistory = UserDefaults.standard.object(forKey: "locationHistory") as? [String] ?? []
    
    var body: some View {
        VStack(spacing:0) {
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 32, height: 4)
                    .foregroundColor(Color(hex: "#646C75"))
                Spacer()
            }
            .padding(.top, 8)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack (alignment: .leading, spacing: 16) {
                    
                    
                    Text("Choose location")
                        .foregroundColor(Color(hex: "#646C75"))
                        .font(.custom("Montserrat-SemiBold", size: 22))
                        .padding(.top, 8)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        if location.count > 0 {
                            Text("Input location name")
                                .font(.custom("Montserrat-Normal", size: 10))
                                .foregroundColor(Color(hex: "#909BA8"))
                        }
                        HStack {
                            ZStack(alignment: .leading) {
                                let textHint = viewModel.cityNames.isEmpty ? "" : viewModel.cityNames.first(where: { $0.starts(with: location)}) ?? ""
                                if isChangingLocation == true {
                                    if textHint.starts(with: location) && location.count > 0 {
                                        Text(textHint)
                                            .font(.custom("Montserrat-Semibold", size: 16))
                                            .foregroundColor(Color(hex: "#A6B3C2"))
                                            .onTapGesture {
                                                location = viewModel.cityNames[0]
                                            }
                                    }
                                }
                                TextField("Input location name",
                                    
                                    text: $location,
                                    
                                    onEditingChanged: { isEditing in
                                        if isEditing {
                                            print("isEditing")
                                            if location.count > 2 {
                                                viewModel.getCityName(prefixName: location)
                                                print("CITY NAMES")
                                                print(viewModel.cityNames)
                                            }
                                            withAnimation {
                                                isChangingLocation = true
                                            }
                                        }
                                    },
                                    
                                    onCommit: {
                                        withAnimation {
                                            if !viewModel.cityNames.isEmpty {
                                                location = viewModel.cityNames[0]
                                            }
                                            if location.trimmingCharacters(in: .whitespaces).count > 0  && location.starts(with: " ") == false {
                                                chosenLocation = location
                                                UserDefaults.standard.set(chosenLocation, forKey: "location")
                                                
                                                if !locationHistory.contains(location) {
                                                    locationHistory.remove(at: 4)
                                                    locationHistory.insert(location, at: 0)
                                                    
                                                    UserDefaults.standard.set(locationHistory, forKey: "locationHistory")
                                                }
                                                
                                                if isGeoposition == true {
                                                    isGeoposition = false
                                                    UserDefaults.standard.set(isGeoposition, forKey: "isGeoposition")
                                                }
                                            }
                                            isChangingLocation = false
                                        }
                                    }
                                )
                                .textFieldStyle(CustomFieldStyle())
                                .multilineTextAlignment(.leading)
                                .onChange(of: location, perform: { _ in
                                    if location != "" {
                                        print("changed")
                                        withAnimation {
                                            isChangingLocation = true
                                        }
                                    }
                                    if location.count > 2 {
                                        print(location)
                                        viewModel.getCityName(prefixName: location)
                                        print("CITY NAMES")
                                        print(viewModel.cityNames)
                                    }
                                })
                            }
                            
                            Spacer()
                            
                            if location.count > 0 {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color(hex: "#646C75"))
                                    .frame(width: 14, height: 14)
                                    .onTapGesture {
                                        location = ""
                                    }
                            }
                        }
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(location.count > 0 ? Color(hex: "#646C75") : Color(hex: "#DADADA"))
                    }
                    .frame(height: 52, alignment: .bottom)
                    
                    

                    if isChangingLocation == true {
                        if location.count > 0 {
                            if viewModel.stateCityName == .success {
                                let capitals: [String] = viewModel.cityNames
                                if capitals.count < 3 {
                                    PlaceholderCities()
                                } else {
                                    VStack (alignment: .leading, spacing: 16) {
                                        ForEach (capitals, id:\.self) { city in
                                            Text(city)
                                                .foregroundColor(Color(hex: "#646C75"))
                                                .font(.custom("Montserrat-Medium", size: 16))
                                                .padding(.leading, 16)
                                                .onTapGesture {
                                                    withAnimation {
                                                        chosenLocation = city
                                                        UserDefaults.standard.set(chosenLocation, forKey: "location")
                                                        
                                                        if !locationHistory.contains(city) {
                                                            locationHistory.remove(at: 4)
                                                            locationHistory.insert(city, at: 0)
                                                            
                                                            UserDefaults.standard.set(locationHistory, forKey: "locationHistory")
                                                        }
                                                        isChangingLocation = false
                                                        location = ""
                                                        viewModel.cityNames = []
                                                    }
                                                }
                                            
                                            RoundedRectangle(cornerRadius: 16)
                                                .frame(height: 1)
                                                .foregroundColor(Color(hex: "#DADADA")).opacity(0.5)
                                        }
                                       
                                    }
                                    .padding(.top, 30)
                                }
                            }
                            if viewModel.stateCityName == .error {
                                PlaceholderErrorCities()
                            }
                            if viewModel.stateCityName == .placeholder {
                                PlaceholderCities()
                            }
                        
                        }
                    } else {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundColor(.white)
                            HStack {
                                if isGeoposition == true {
                                    Image(systemName: "location.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color(hex: "#678CD4"))
                                        .frame(width: 20, height: 20)
                                } else {
                                    Image(systemName: "location")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color(hex: "#646C75"))
                                        .frame(width: 20, height: 20)
                                }
                                Text("Current geoposition")
                                    .foregroundColor(Color(hex: "#646C75"))
                                    .font(.custom("Montserrat-Medium", size: 14))
                                Spacer()
                                if isGeoposition == true {
                                    ZStack {
                                        Circle()
                                            .foregroundColor(.green)
                                            .frame(width: 18, height: 18)
                                        Image("Ok")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.white)
                                            .frame(width: 12, height: 12)
                                    }
                                }
                                
                            }
                            .padding(.horizontal, 16)
                        }
                        .padding(.top, 8)
                        .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
                        .frame(height: 56)
                        .onTapGesture {
                            isGeoposition.toggle()
                            UserDefaults.standard.set(isGeoposition, forKey: "isGeoposition")
    //                        print(chosenLocation)
    //                        print("AAAAAA")
    //                        print(isGeoposition)
    //                        print(UserDefaults.standard.string(forKey: "location"))
                        }
                        
                        if !locationHistory.isEmpty {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .foregroundColor(.white)
                                VStack(spacing: 16) {
                                    ForEach (0..<locationHistory.count, id:\.self) { item in
                                        if item != 0 {
                                            Rectangle()
                                                .foregroundColor(Color(hex: "#DADADA")).opacity(0.5)
                                                .frame(height: 1)
                                        }
                                        ZStack {
                                            Rectangle()
                                                .foregroundColor(.white)
                                            HStack {
                                                Text(locationHistory[item])
                                                    .foregroundColor(Color(hex: "#646C75"))
                                                    .font(.custom("Montserrat-Medium", size: 14))
                                                Spacer()
                                                if chosenLocation == locationHistory[item] && isGeoposition == false {
                                                    ZStack {
                                                        Circle()
                                                            .foregroundColor(.green)
                                                            .frame(width: 18, height: 18)
                                                        Image("Ok")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .foregroundColor(.white)
                                                            .frame(width: 12, height: 12)
                                                    }
                                                }
                                            }
                                        }
                                        .frame(height: 18)
                                        .onTapGesture {
                                            chosenLocation = locationHistory[item]
                                            UserDefaults.standard.set(chosenLocation, forKey: "location")
                                            isGeoposition = false
                                            UserDefaults.standard.set(isGeoposition, forKey: "isGeoposition")
                                        }
                                    }
                                }
                                .padding(16)
                            }
                            .padding(.top, 8)
                            
                        }
                            
                    }
                    
                }
                .padding(.horizontal, 24)
            }
        }
        .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
        .onDisappear {
            if isGeoposition == true {
                viewModel.getWeatherData(lat: viewModel.coordinates.lat, long: viewModel.coordinates.lon, locationName: nil) {
                    chosenLocation = viewModel.weather.city.name
                    UserDefaults.standard.set(chosenLocation, forKey: "location")
                    self.viewModel.days = viewModel.parseWeatherData(data: viewModel.weather)
                    withAnimation {
                        viewModel.changeWeather(id: viewModel.selectedId)
                    }
                }
            } else {
                viewModel.getWeatherData(lat: nil, long: nil, locationName: chosenLocation) {
                    self.viewModel.days = viewModel.parseWeatherData(data: viewModel.weather)
                    withAnimation {
                        viewModel.changeWeather(id: viewModel.selectedId)
                    }
                }
            }
        }
    }
}

struct ChooseLocationView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLocationView()
    }
}
