//
//  AvailableTypesView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI

struct AvailableTypesView: View {
    @State var showSheet = false
//    @ObservedObject var viewModel: ProfileViewModel
    @StateObject private var viewModel = ProfileViewModel.shared
    
    let allTypes = GetClothes.getClothes()
    
    
    var body: some View {
        Button {
            showSheet.toggle()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundColor(.white)
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Select type of clothing")
                            .foregroundColor(Color(hex: "#646C75"))
                            .font(.custom("Montserrat-Medium", size: 16))
                        Spacer()
                    }
                    CleanTagsView(items: viewModel.chosenClothes)
                }
                .padding(16)
            }
            .edgesIgnoringSafeArea(.all)
            .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
            .sheet(isPresented: $showSheet) {
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
                        Text("Select type of clothing")
                            .foregroundColor(Color(hex: "#646C75"))
                            .font(.custom("Montserrat-SemiBold", size: 22))
                            .padding(.top, 8)
                        
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack (spacing: 16) {
                            
                                ForEach(0..<allTypes.count) { id in
                                    if viewModel.chosenClothes.contains(allTypes[id].clothesTypeName.rawValue) {
                                        ListItem(name: allTypes[id].clothesTypeName.rawValue, isPicked: true)
                                            .onTapGesture {
                                                if let index = viewModel.chosenClothes.firstIndex(where: {$0 == allTypes[id].clothesTypeName.rawValue }) {
                                                    viewModel.chosenClothes.remove(at: index)
                                                    UserDefaults.standard.set(viewModel.chosenClothes, forKey: "chosenClothesTypes")
                                                }
                                            }
                                    } else {
                                        ListItem(name: allTypes[id].clothesTypeName.rawValue, isPicked: false)
                                            .onTapGesture {
                                                if id < viewModel.chosenClothes.count {
                                                    viewModel.chosenClothes.insert(allTypes[id].clothesTypeName.rawValue, at: id)
                                                } else {
                                                    viewModel.chosenClothes.append(allTypes[id].clothesTypeName.rawValue)
                                                }
                                                
                                                UserDefaults.standard.set(viewModel.chosenClothes, forKey: "chosenClothesTypes")
                                            }
                                    }
                                    RoundedRectangle(cornerRadius: 16)
                                        .frame(height: 1)
                                        .foregroundColor(Color(hex: "#EFF0F2"))
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
                            UserDefaults.standard.set(viewModel.chosenClothes, forKey: "chosenClothesTypes")
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
