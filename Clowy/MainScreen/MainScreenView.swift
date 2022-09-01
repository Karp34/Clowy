//
//  ContentView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 14.04.2022.
//

import SwiftUI
import Foundation
import AVFAudio

class MainScreenViewModel: ObservableObject {
}
    

struct MainScreenView: View, DaysForecastViewDelegate {

    @ObservedObject var viewModel = MainScreenViewModel()
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    
    @State var chosenWeather: Weather = Weather(color: "#cc0000", icon: "cloud", temp: "20")
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
        chosenWeather = days.first(where: { $0.id == id })?.weather ?? Weather(color: "#cc0000", icon: "cloud", temp: "666")
    }
                                                
                                                
    private func getDays() {
        let resultDays = WeatherForecast.getDays()
        days = resultDays
        if let first = resultDays.first {
            selectedId = first.id
            chosenWeather.color = first.weather.color
            chosenWeather.temp = first.weather.temp
            chosenWeather.icon = first.weather.icon
        }
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
    
    
    
    var launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")

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
            if #available(iOS 14.0, *) {
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
                            color: chosenWeather.color,
                            temp: chosenWeather.temp,
                            icon: chosenWeather.icon)
                        .padding(.horizontal)
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
                    print(outfits.first(where: { $0.id == selectedId })?.outfit as Any)
                    getDays()
                    getOutfits()
                    getClothes()
                    createWardrobe(wardrobe: clothes)
                }
                .onAppear {
                    UIApplication.shared.setStatusBarStyle(.darkContent, animated: false)
                }
                .navigationBarHidden(true)
                .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
            } else {
                // Fallback on earlier versions
            }
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
