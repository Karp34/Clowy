//
//  AvailableTypesView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//
import SwiftUI

struct AvailableTypesView: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State var showSheet = false

    let allTypes = CreateDefaultWardrobe.getClothes()
    let notDeletableClothes: [Wardrobe] = [
        Wardrobe(id: .hoodies,   clothesTypeName: .hoodies,   items: [], ratio: .rectangle),
        Wardrobe(id: .tshirts,   clothesTypeName: .tshirts,   items: [], ratio: .rectangle),
        Wardrobe(id: .pants,     clothesTypeName: .pants,     items: [], ratio: .rectangle),
        Wardrobe(id: .sneakers,  clothesTypeName: .sneakers,  items: [], ratio: .square)
    ]

    var body: some View {
        Button { showSheet.toggle() } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16).foregroundColor(.white)
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Clothes you don't wear")
                            .foregroundColor(Color.primaryGrey)
                            .font(.custom("Montserrat-Medium", size: 16))
                        Spacer()
                    }
                    if profileViewModel.user.excludedClothes.isEmpty {
                        Text("Tap to remove clothes types from wardrobe")
                            .foregroundColor(Color.primaryGrey)
                            .font(.custom("Montserrat-Regular", size: 12))
                    } else {
                        CleanTagsView(items: profileViewModel.user.excludedClothes).padding(.top, 8)
                    }
                }
                .padding(16)
            }
            .edgesIgnoringSafeArea(.all)
            .shadow(color: Color.shadowGrey.opacity(0.1), radius: 35, x: 0, y: 8)
            .sheet(isPresented: $showSheet, onDismiss: {
                Task { await profileViewModel.updateUser() }
            }) {
                ZStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 16).frame(width: 32, height: 4).foregroundColor(Color.primaryGrey)
                            Spacer()
                        }
                        .padding(.top, 8)
                        Text("Select clothes you don't wear")
                            .foregroundColor(Color.primaryGrey)
                            .font(.custom("Montserrat-SemiBold", size: 22))
                            .padding(.top, 8)
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 16) {
                                ForEach(allTypes) { type in
                                    if !notDeletableClothes.contains(type) {
                                        let isInList = profileViewModel.user.excludedClothes.contains(type.clothesTypeName.rawValue.lowercased())
                                        ListItem(name: type.clothesTypeName.rawValue, isPicked: isInList)
                                            .onTapGesture { updateClothesList(cloth: type.clothesTypeName.rawValue.lowercased()) }
                                        RoundedRectangle(cornerRadius: 16).frame(height: 1).foregroundColor(Color.secondaryGrey)
                                    }
                                }
                                Spacer(minLength: 138)
                            }
                            .padding(.top, 16)
                        }
                    }
                    .padding(.horizontal, 24)

                    ZStack(alignment: .bottom) {
                        Rectangle().foregroundColor(.clear)
                            .background(LinearGradient(colors: [.white.opacity(0), .white], startPoint: .top, endPoint: .bottom))
                            .frame(height: 178)
                        Button {
                            Task { await profileViewModel.updateUser() }
                            showSheet = false
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16).frame(height: 56).foregroundColor(Color.primaryGrey)
                                Text("SAVE").foregroundColor(.white).font(.custom("Montserrat-Bold", size: 16))
                            }
                        }
                        .padding(.horizontal, 24).padding(.bottom, 40)
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }

    func updateClothesList(cloth: String) {
        if let index = profileViewModel.user.excludedClothes.firstIndex(of: cloth) {
            profileViewModel.user.excludedClothes.remove(at: index)
        } else {
            profileViewModel.user.excludedClothes.append(cloth)
        }
    }
}

struct ListItem: View {
    var name: String
    var isPicked: Bool
    
    var body: some View {
        HStack {
            Text(name)
                .foregroundColor(Color.primaryGrey)
                .font(.custom("Montserrat-Medium", size: 16))
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: 24, height: 24)
                    .foregroundColor(isPicked ? Color.primaryBlueBrand : Color.secondaryGrey)
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
