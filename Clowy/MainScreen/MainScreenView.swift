//
//  ContentView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 14.04.2022.
//

import SwiftUI
import Foundation
import AVFAudio
//import Combine

struct MainScreenView: View, DaysForecastViewDelegate {
    
    @StateObject private var viewModel = MainScreenViewModel.shared
    @Environment(\.managedObjectContext) var managedObjectContext
    @State private var tabState: Visibility = .hidden
    
    
    
    @State var offset: CGPoint = .zero
    @State var backgroundOffset: CGFloat = 0
    
    let defaultOutfit = [
        Cloth(id: "1100", name: "", type: .tshirts, color: "", temperature: [], isDefault: true, image: "DefaultUpperWear", rawImage: nil),
        Cloth(id: "1100", name: "", type: .tshirts, color: "", temperature: [], isDefault: true, image: "DefaultPants", rawImage: nil),
        Cloth(id: "1102", name: "", type: .sneakers, color: "", temperature: [], isDefault: true, image: "DefaultSneaker", rawImage: nil)
    ]
    
    private func createWardrobe(wardrobe: [Wardrobe]) {
        if UserDefaults.standard.bool(forKey: "launchedBefore") == false {
            
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
        let listOfOutfits = viewModel.fittingOutfitsResponse.first(where: { $0.id == viewModel.selectedId })?.outfits ?? []
        NavigationStack {
            ZStack {
                GeometryReader { g in
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                            NavigationLink(
                                destination: ProfileView()
                            ) {
                                GreetingView(color: viewModel.chosenWeather.color, username: viewModel.user.username, avatar: viewModel.user.userIcon)
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 32)
                            .padding(.top, 24)
                            .buttonStyle(NoAnimationButtonStyle())
                            
                            WeatherForecastView(
                                name: viewModel.chosenWeather.name,
                                color: viewModel.chosenWeather.color,
                                temp: viewModel.chosenWeather.temp,
                                icon: viewModel.chosenWeather.icon,
                                state: viewModel.state)
                            
                            
                            
                            WardrobeModuleView(color: viewModel.chosenWeather.color, numberOfClothes: viewModel.clothes.count, numberOfOutfits: viewModel.outfits.count)
                                .padding(.horizontal, 24)
                                .padding(.bottom, 32)
                            
                            if viewModel.state == .success {
                                Section {
                                    if let fittingOutfits = viewModel.fittingOutfitsResponse.first(where: { $0.id == viewModel.selectedId }) {
                                        if !fittingOutfits.outfits.isEmpty {
                                            HStack(alignment: .top, spacing: 0) {
                                                ForEach(fittingOutfits.outfits) { outfit in
                                                    VStack(spacing: 8) {
                                                        ClothesCardsView(outfit: outfit.outfit, notRealClothesTemps: viewModel.notRealClothesTemps, color: viewModel.chosenWeather.color)
                                                            .padding(.horizontal, 16)
                                                        AddGeneratedOutfit(isGenerated: outfit.isGenerated, outfit: outfit.outfit)
                                                        if fittingOutfits.outfits.count > 1 {
                                                            Spacer()
                                                                .frame(height: 56)
                                                        }
                                                       
                                                        
                                                    }
                                                    .frame(width: g.size.width)
                                                }
                                            }
                                            .offset(x: -(self.backgroundOffset * g.size.width))
                                            .animation(.default)
                                        } else {
                                            NoOutfit(textError: fittingOutfits.error, errorCode: fittingOutfits.code)
                                                .padding(.horizontal, 24)
                                        }
                                    }
                                } header: {
                                    DaysForecastView(
                                        delegate: self,
                                        days: viewModel.days,
                                        selectedId: viewModel.selectedId)
                                    .background((offset.y > 360 ? Color(hex: "#F7F8FA") : Color(.clear)).frame(height: 95).edgesIgnoringSafeArea(.all).offset(y: -30))
                                }
                            } else if viewModel.state == .error {
                                HStack {
                                    Spacer()
                                    NoClothesDataPlaceholder()
                                    Spacer()
                                }
                            } else {
                                ClothesLoadingPlaceholder()
                            }
                        }
                        .readingScrollView(from: "scroll", into: $offset)
                        
                    }
                    .coordinateSpace(name: "scroll")
                    .gesture(DragGesture()
                        .onEnded({ value in
                            if value.translation.width > 10 {
                                if backgroundOffset > 0 {
//                                    withAnimation {
                                        self.backgroundOffset -= 1
//                                    }
                                }
                            } else if value.translation.width < -10 {
                                if Int(backgroundOffset) < listOfOutfits.count-1 {
//                                    withAnimation {
                                        self.backgroundOffset += 1
//                                    }
                                }
                                
                            }
                        })
                    )
                    .onAppear {
                        
                        createWardrobe(wardrobe: viewModel.wardrobe)
                        
                        if UserDefaults.standard.bool(forKey: "isGeoposition") == true {
                            if (viewModel.coordinates != nil) {
                                viewModel.getWeatherData(lat: viewModel.coordinates!.lat, long: viewModel.coordinates!.lon, locationName: nil) {
                                    self.viewModel.days = viewModel.parseWeatherData(data: viewModel.weather)
                                    withAnimation {
                                        viewModel.changeWeather(id: viewModel.selectedId)
                                    }
                                    print("geo")
                                    print(viewModel.coordinates)
                                    print(viewModel.weather)
                                    print(viewModel.days)
                                    
                                    viewModel.getRightOutfits()
                                    print("GET RIGHT OUFIT")
                                }
                            }
                        } else {
                            viewModel.getWeatherData(lat: nil, long: nil, locationName: UserDefaults.standard.string(forKey: "location")
                            ) {
                                self.viewModel.days = viewModel.parseWeatherData(data: viewModel.weather)
                                withAnimation {
                                    viewModel.changeWeather(id: viewModel.selectedId)
                                }
                                print("loc")
                                print(UserDefaults.standard.string(forKey: "location"))
                                print(viewModel.days)
                                
                                viewModel.getRightOutfits()
                                print("GET RIGHT OUFIT")
                            }
                        }
                        
                        
                        
                    }
                    .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
                }
                VStack {
                    Spacer()
                    if listOfOutfits.count > 1 {
                        IndicatorView(selectedId: Int(backgroundOffset), count: listOfOutfits.count)
                            .animation(.easeInOut, value: backgroundOffset)
                            .onDisappear {
                                backgroundOffset = 0
                            }
                    }
                }
            }
        }
        .navigationTitle("Hello")
        .toolbar(tabState, for: .navigationBar)
    }
    
    func dayIsChanged(id: Int) {
        viewModel.changeWeather(id: id)
        backgroundOffset = 0
    }
}
