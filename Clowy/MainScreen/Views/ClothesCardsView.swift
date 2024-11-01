//
//  ClothesCardsView.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 03.12.2022.
//

import SwiftUI
import WaterfallGrid

struct ClothesCardsView: View {
    var outfit: [Cloth]
    var textError: String?
    var errorCode: Int?
    var notRealClothesTemps: [NotRealCloth]?
    var color: String?
    
    var body: some View {
        ZStack {
            if !outfit.isEmpty {
                WaterfallGrid(outfit) { item in
                    ClothesCard(cloth: item, notRealClothesTemps: notRealClothesTemps, color: color)
                        .aspectRatio(GetRatio.getRatio(type: item.type).rawValue, contentMode: .fit)
                }
                .padding(.horizontal, 4)
            } else {
                NoOutfit(textError: textError)
                    .padding(.horizontal, 8)
                    
            }
        }
        .onAppear {
            print("NO OUTFIT")
            print(outfit)
            print(textError)
        }
    }
}

struct ClothesCard: View {
    @StateObject private var addClothesViewModel = AddClothesViewModel.shared
    @State var cloth: Cloth
    var notRealClothesTemps: [NotRealCloth]?
    var color: String?
    @State var isShowingSheet = false

    var body: some View {
        if cloth.id.starts(with: "Not real cloth") {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.white)
                VStack (spacing: 12){
                    ClothImage(imageName: cloth.image, isDeafult: cloth.isDefault, color: cloth.color, rawImage: cloth.rawImage)
                        .scaledToFit()
                        .frame(width: 100, height: 120)
                        .opacity(0.5)
                    VStack(spacing: 4) {
                        Text(cloth.name)
                            .font(.custom("Montserrat-Regular", size: 14))
                            .multilineTextAlignment(.center)
                            .frame(width: 120)
                            .scaledToFill()
                            .foregroundColor(Color(hex: "#606060"))
                        Text("Not real cloth. Tap to add yours")
                            .font(.custom("Montserrat-Regular", size: 10))
                            .multilineTextAlignment(.center)
                            .frame(width: 120)
                            .scaledToFill()
                            .foregroundColor(Color(hex: "#646C75"))
                    }
                }
                .padding()
                if let notRealClothesTemps {
                    if !notRealClothesTemps.isEmpty {
                        VStack {
                            HStack{
                                Spacer()
                                if let temp = notRealClothesTemps.first(where: {$0.id == cloth.id})?.temp {
                                    let tempName = GetTemperatureRange.getTemperatureRange(type: temp).components(separatedBy: " ").dropLast().dropFirst().joined(separator: " ")
                                    Text(tempName)
                                        .font(.custom("Montserrat-Regular", size: 10))
                                        .foregroundColor(Color(hex: "#FFFFFF"))
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 4)
                                        .background(Color(hex: color ?? "#74A3FF"))
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                }
                            }
                            Spacer()
                        }
                        .padding(8)
                    }
                }
            }
            .shadow(color:Color(hex: "#646C75").opacity(0.15), radius: 30, y: 4)
            .padding(4)
            .onTapGesture {
                isShowingSheet = true
                addClothesViewModel.cloth = cloth
                addClothesViewModel.temp = GetTemperatureRange.decodeTemperature(listTemp: cloth.temperature)
            }
            .sheet(isPresented: $isShowingSheet) {
                AddClothesView(isEdtitngCloth: true, isShowingSheet: $isShowingSheet)
            }
        } else {
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.white)
                VStack (spacing: 12) {
                    ClothImage(imageName: cloth.image, isDeafult: cloth.isDefault, color: cloth.color, rawImage: cloth.rawImage)
                        .scaledToFit()
                        .frame(width: 100, height: 120)
                    Text(cloth.name)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .multilineTextAlignment(.center)
                        .frame(width: 120)
                        .scaledToFill()
                        .foregroundColor(Color(hex: "#606060"))
                    
                }
                .padding()
            }
            .shadow(color:Color(hex: "#646C75").opacity(0.15), radius: 30, y: 4)
            .padding(4)
        }
        
    }
}

struct NoOutfit : View {
    @StateObject private var viewModel = MainScreenViewModel.shared
    @State var isShowingSheet = false
    @State var isPresented = false
    var textError: String?
    var errorCode: Int?
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .center, spacing: 16) {
                ZStack {
                    Circle()
                        .frame(width: 96, height: 96)
                        .foregroundColor(Color(hex: viewModel.chosenWeather.color)).opacity(0.2)
                    Image("Veshalka")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 41)
                        .foregroundColor(Color(hex: viewModel.chosenWeather.color))
                }
                if let textError = textError {
                    Text(textError)
                        .font(.custom("Montserrat-SemiBold", size: 20))
                        .foregroundColor(Color(hex: "#646C75"))
                        .multilineTextAlignment(.center)
                } else {
                    Text("No items in wardrobe")
                        .font(.custom("Montserrat-SemiBold", size: 20))
                        .foregroundColor(Color(hex: "#646C75"))
                        .multilineTextAlignment(.center)
                }
                
            }
            .frame(idealWidth: 279 ,idealHeight: 320)
            
            Spacer()
            
            Button {
                if errorCode == 401 {
                    isShowingSheet.toggle()
                } else if errorCode == 402 {
                    isPresented.toggle()
                } else {
                    print("TADA")
                    isShowingSheet.toggle()
                }
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                    Text("Add")
                        .font(.custom("Montserrat-Bold", size: 16))
                        .foregroundColor(.white)
                }

            }
            .padding(.bottom, 24)
            .buttonStyle(DefaultColorButtonStyle(color: viewModel.chosenWeather.color, radius: 24))
            .sheet(isPresented: $isShowingSheet) {
                AddClothesView(isShowingSheet: $isShowingSheet)
            }
            .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
            .fullScreenCover(isPresented: $isPresented) {
                AddNewOutfitView()
            }
        }
    }
}
