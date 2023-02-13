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
    
    

    
    @State var offset: CGPoint = .zero
    
    
    let defaultOutfit = [
            Cloth(id: 1100, name: "", clothesType: .tshirts, image: "DefaultUpperWear"),
            Cloth(id: 1101, name: "", clothesType: .pants, image: "DefaultPants"),
            Cloth(id: 1102, name: "", clothesType: .sneakers, image: "DefaultSneaker")
        ]
    
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
                        GreetingView(color: viewModel.chosenWeather.color)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 32)
                            .padding(.top, 24)
                        
                    }
                    .buttonStyle(NoAnimationButtonStyle())
                    
                    Button {
                    } label: {
                        WeatherForecastView(
                            name: viewModel.chosenWeather.name,
                            color: viewModel.chosenWeather.color,
                            temp: viewModel.chosenWeather.temp,
                            icon: viewModel.chosenWeather.icon,
                            state: viewModel.state)
                    }
                    .buttonStyle(ScaleButtonStyle())
                 
                    

                    WardrobeModuleView(color: viewModel.chosenWeather.color, numberOfClothes: items.count, numberOfOutfits: 0)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    
                    if viewModel.state == .success {
                        Section {
                            ClothesCardsView(outfit: viewModel.outfits.first(where: { $0.id == viewModel.selectedId })?.outfit ?? [])
                                .padding(.horizontal, 16)
                            
                            AddGeneratedOutfit(isGenerated: viewModel.outfits.first(where: { $0.id == viewModel.selectedId })?.isGenerated ?? false, outfit: viewModel.outfits.first(where: { $0.id == viewModel.selectedId })?.outfit ?? defaultOutfit)
                        } header: {
                            DaysForecastView(
                                delegate: self,
                                days: viewModel.days,
                                selectedId: viewModel.selectedId)
                            .background((offset.y > 380 ? Color(hex: "#F7F8FA") : Color(.clear)).frame(height: 95).edgesIgnoringSafeArea(.all).offset(y: -30))
                        }
                    } else if viewModel.state == .error {
                        NoClothesDataPlaceholder()
                    } else {
                        ClothesLoadingPlaceholder()
                    }
                    
                }
                .readingScrollView(from: "scroll", into: $offset)
                
            }
            .coordinateSpace(name: "scroll")
            .onAppear {
                print("_________name")
                print(viewModel.chosenWeather.name)
                print("_________color")
                print(viewModel.chosenWeather.color)
                print("_________temp")
                print(viewModel.chosenWeather.temp)
                print("_________icon")
                print(viewModel.chosenWeather.icon)
                print("_________state")
                print(viewModel.state)
            }
            .onAppear {
                viewModel.getOutfits()
                viewModel.getClothes()
                createWardrobe(wardrobe: viewModel.clothes)
                UIApplication.shared.setStatusBarStyle(.darkContent, animated: false)
                
                viewModel.getCoordinates() { coordinates in
                    if UserDefaults.standard.bool(forKey: "isGeoposition") == true {
                        print(viewModel.coordinates)
                        viewModel.getWeatherData(lat: viewModel.coordinates.lat, long: viewModel.coordinates.lon, locationName: nil) {
                            self.viewModel.days = viewModel.parseWeatherData(data: viewModel.weather)
                            withAnimation {
                                viewModel.changeWeather(id: viewModel.selectedId)
                            }
                            print("geo")
                            print(viewModel.coordinates)
                            print(viewModel.weather)
                            print(viewModel.days)
                        }
                    } else {
                        viewModel.getWeatherData(lat: nil, long: nil, locationName: UserDefaults.standard.string(forKey: "location") ) {
                            self.viewModel.days = viewModel.parseWeatherData(data: viewModel.weather)
                            withAnimation {
                                viewModel.changeWeather(id: viewModel.selectedId)
                            }
                            print("loc")
                            print(UserDefaults.standard.string(forKey: "location"))
                            print(viewModel.days)
                        }
                    }
                }
                viewModel.observeDeniedLocationAccess()
                viewModel.deviceLocationService.requestLocationUpdates()
            }
            .navigationBarHidden(true)
            .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
        }
    }
    
    func dayIsChanged(id: Int) {
        viewModel.changeWeather(id: id)
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
