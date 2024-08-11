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
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            HStack {
                Spacer()
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 32, height: 4)
                    .foregroundColor(Color(hex: "#646C75"))
                Spacer()
            }
            
            Text("Choose location")
                .foregroundColor(Color(hex: "#646C75"))
                .font(.custom("Montserrat-SemiBold", size: 22))
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    ZStack(alignment: .leading) {
                        let textHint = viewModel.cityNames.isEmpty ? "" : viewModel.cityNames.first(where: { $0.starts(with: location)}) ?? ""
                        if isChangingLocation {
                            if textHint.starts(with: location) && location.count > 0 {
                                Text(textHint)
                                    .font(.custom("Montserrat-SemiBold", size: 16))
                                    .foregroundColor(Color(hex: "#A6B3C2"))
                                    .onTapGesture {
                                        location = viewModel.cityNames[0]
                                    }
                            }
                        }
                        TextField("Input location name", text: $location,
                            
                            onEditingChanged: { isEditing in
                                if isEditing {
                                    print("isEditing")
//                                    if location.count > 2 {
//                                        viewModel.getCityName(prefixName: location) {
//                                            print("onEditingChanged")
//                                            print("CITY NAMES")
//                                            print(viewModel.cityNames)
//                                        }
//                                    }
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
                                    let finalLocation = location.trimmingCharacters(in: .whitespaces)
                                    if finalLocation.count > 0 {
                                        chosenLocation = finalLocation
                                        UserDefaults.standard.set(chosenLocation, forKey: "location")
                                        
                                        if !locationHistory.contains(location) {
                                            locationHistory.remove(at: 4)
                                            locationHistory.insert(location, at: 0)
                                            
                                            UserDefaults.standard.set(locationHistory, forKey: "locationHistory")
                                        }
                                        
                                        if isGeoposition {
                                            isGeoposition = false
                                            UserDefaults.standard.set(isGeoposition, forKey: "isGeoposition")
                                        }
                                    }
                                    isChangingLocation = false
                                }
                            }
                        )
                        .onChange(of: location) {
                            print("location", location.isEmpty ? "is Empty" : location)
                            if location.count > 2 {
                                viewModel.getCityName(prefixName: location) {
                                    print("location2", location.isEmpty ? "is Empty" : location)
                                    print("Change of location")
                                    print("CITY NAMES")
                                    print(viewModel.cityNames)
                                    print("-----------")
                                }
                            }
                        }
                        .textFieldStyle(CustomFieldStyle())
                        .multilineTextAlignment(.leading)
                        .focused($isTextFieldFocused)
                    }
                    .overlay {
                        if location.count > 0 {
                            HStack {
                                Text("Input location name")
                                    .font(.custom("Montserrat-Normal", size: 10))
                                    .foregroundColor(Color(hex: "#909BA8"))
                                    .padding(.bottom, 34)
                                Spacer()
                            }
                        }
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
                    .foregroundColor(isChangingLocation ? Color(hex: "#646C75") : Color(hex: "#DADADA"))
            }
            .frame(height: 32, alignment: .bottom)
            
            if isChangingLocation {
                if location.count > 1 {
                    if viewModel.stateCityName == .success {
                        let capitals: [String] = viewModel.cityNames
                        ScrollView(showsIndicators: false) {
                            VStack (alignment: .leading, spacing: 16) {
                                ForEach (capitals, id:\.self) { city in
                                    Text(city)
                                        .foregroundColor(Color(hex: "#646C75"))
                                        .font(.custom("Montserrat-Medium", size: 16))
                                        .padding(.leading, 16)
                                        .onTapGesture {
                                            withAnimation {
                                                location = ""
                                                viewModel.cityNames = []
                                                chosenLocation = city
                                                UserDefaults.standard.set(chosenLocation, forKey: "location")
                                                isChangingLocation = false
                                                isTextFieldFocused = false
                                                
                                                
                                                if !locationHistory.contains(city) {
                                                    locationHistory.remove(at: 4)
                                                    locationHistory.insert(city, at: 0)
                                                    
                                                    UserDefaults.standard.set(locationHistory, forKey: "locationHistory")
                                                }
                                            }
                                        }
                                    
                                    RoundedRectangle(cornerRadius: 16)
                                        .frame(height: 1)
                                        .foregroundColor(Color(hex: "#DADADA")).opacity(0.5)
                                }
                            }
                        }
                        .padding(.top, 16)
                    }
                    if viewModel.stateCityName == .error {
                        PlaceholderErrorCities()
                    }
                    if viewModel.stateCityName == .placeholder {
                        PlaceholderCities()
                    }
                } else {
                    PlaceholderCities()
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.white)
                    HStack {
                        if isGeoposition{
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
                }
                
                if !locationHistory.isEmpty {
                    VStack(spacing: 16) {
                        ForEach (0..<locationHistory.count, id:\.self) { item in
                            if item != 0 {
                                Rectangle()
                                    .foregroundColor(Color(hex: "#DADADA")).opacity(0.5)
                                    .frame(height: 1)
                            }
                            ZStack {
                                HStack {
                                    Text(locationHistory[item])
                                        .foregroundColor(Color(hex: "#646C75"))
                                        .font(.custom("Montserrat-Medium", size: 14))
                                    Spacer()
                                    if chosenLocation == locationHistory[item] && !isGeoposition {
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
                                        .padding(3)
                                    }
                                }
                            }
                            .frame(height: 18)
                            .padding(.horizontal, 16)
                            .onTapGesture {
                                chosenLocation = locationHistory[item]
                                UserDefaults.standard.set(chosenLocation, forKey: "location")
                                isGeoposition = false
                                UserDefaults.standard.set(isGeoposition, forKey: "isGeoposition")
                            }
                        }
                    }
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
                }
            }
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 24)
        .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
        .onDisappear {
            if isGeoposition {
                if (viewModel.coordinates != nil) {
                    viewModel.getWeatherData(lat: viewModel.coordinates!.lat, long: viewModel.coordinates!.lon, locationName: nil) {
                        chosenLocation = viewModel.weather.city.name
                        UserDefaults.standard.set(chosenLocation, forKey: "location")
                        self.viewModel.days = viewModel.parseWeatherData(data: viewModel.weather)
                        withAnimation {
                            viewModel.changeWeather(id: viewModel.selectedId)
                            viewModel.getRightOutfits()
                        }
                    }
                }
            } else {
                viewModel.getWeatherData(lat: nil, long: nil, locationName: chosenLocation) {
                    self.viewModel.days = viewModel.parseWeatherData(data: viewModel.weather)
                    withAnimation {
                        viewModel.changeWeather(id: viewModel.selectedId)
                        viewModel.getRightOutfits()
                    }
                }
            }
        }
    }
}
