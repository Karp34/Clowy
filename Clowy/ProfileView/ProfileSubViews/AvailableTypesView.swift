//
//  AvailableTypesView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI

struct AvailableTypesView: View {
    @State var showSheet = false
    @StateObject private var mainViewModel = MainScreenViewModel.shared
    
    let allTypes = CreateDefaultWardrobe.getClothes()
    let notDeletableCLothes: [Wardrobe] = [
        Wardrobe(id: .hoodies, clothesTypeName: .hoodies, items: [], ratio: .rectangle),
        Wardrobe(id: .tshirts, clothesTypeName: .tshirts, items: [], ratio: .rectangle),
        Wardrobe(id: .pants, clothesTypeName: .pants, items: [], ratio: .rectangle),
        Wardrobe(id: .sneakers, clothesTypeName: .sneakers, items: [], ratio: .square)
    ]
    
    
    var body: some View {
        Button {
            showSheet.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.white)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Clothes you don't wear")
                            .foregroundColor(Color(hex: "#646C75"))
                            .font(.custom("Montserrat-Medium", size: 16))
                        Spacer()
                    }
                    if mainViewModel.user.excludedClothes.isEmpty {
                        Text("Tap to remove clothes types from wardrobe")
                            .foregroundColor(Color(hex: "#646C75"))
                            .font(.custom("Montserrat-Regular", size: 12))
                    } else {
                        CleanTagsView(items: mainViewModel.user.excludedClothes)
                            .padding(.top, 8)
                    }
                }
                .padding(16)
            }
            .edgesIgnoringSafeArea(.all)
            .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
            .sheet(isPresented: $showSheet, onDismiss: {
                mainViewModel.updateUser { _ in }
            }) {
                ZStack (alignment: .bottom) {
                    VStack (alignment: .leading, spacing: 8) {
                        HStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: 32, height: 4)
                                .foregroundColor(Color(hex: "#646C75"))
                            Spacer()
                        }
                        .padding(.top, 8)
                        Text("Select clothes you don't wear")
                            .foregroundColor(Color(hex: "#646C75"))
                            .font(.custom("Montserrat-SemiBold", size: 22))
                            .padding(.top, 8)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack (spacing: 16) {
                                ForEach(allTypes) { type in
                                    if !notDeletableCLothes.contains(type) {
                                        let isInList = mainViewModel.user.excludedClothes.contains(type.clothesTypeName.rawValue.lowercased())
                                        ListItem(
                                            name: type.clothesTypeName.rawValue,
                                            isPicked: isInList
                                        )
                                        .onTapGesture {
                                            updateClothesList(cloth: type.clothesTypeName.rawValue.lowercased())
                                        }
                                        
                                        RoundedRectangle(cornerRadius: 16)
                                            .frame(height: 1)
                                            .foregroundColor(Color(hex: "#EFF0F2"))
                                    }
                                }
                                Spacer(minLength: 138)
                            }
                            .padding(.top, 16)
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    ZStack (alignment: .bottom) {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(LinearGradient(colors: [.white.opacity(0), .white], startPoint: .top, endPoint: .bottom))
                            .frame(height: 178)
                        
                        Button {
                            mainViewModel.updateUser { _ in }
                            showSheet = false
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .frame(height: 56)
                                    .foregroundColor(Color(hex: "#678CD4"))
                                Text("SAVE")
                                    .foregroundColor(Color(hex: "#FFFFFF"))
                                    .font(.custom("Montserrat-Bold", size: 16))
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }

                }
                .edgesIgnoringSafeArea(.all)
            }
            
        }
        .buttonStyle(ScaleButtonStyle())
    }
    
    func updateClothesList(cloth: String) {
        if mainViewModel.user.excludedClothes.contains(cloth) {
            if let index = mainViewModel.user.excludedClothes.firstIndex(where: {$0 == cloth}) {
                mainViewModel.user.excludedClothes.remove(at: index)
            }
        } else {
            mainViewModel.user.excludedClothes.append(cloth)
        }
    }
}

struct ListItem: View {
    var name: String
    var isPicked: Bool?
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundColor(Color(hex: "#646C75"))
                .font(.custom("Montserrat-Medium", size: 16))
            Spacer()
            if isPicked != nil {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(hex: isPicked == true ? "#678CD4" : "#EFF0F2"))
                    if isPicked == true {
                        Image("Ok")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.white)
                            .frame(width: 12, height: 10)
                    }
                }
            }
        }
    }
}
