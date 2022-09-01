//
//  ChooseLocationView.swift
//  Clowy
//
//  Created by Егор Карпухин on 01.09.2022.
//

import SwiftUI

struct ChooseLocationView: View {
    @State var location = ""
    @State var chosenLocation = UserDefaults.standard.string(forKey: "location")
    @State var isGeoposition = UserDefaults.standard.bool(forKey: "isGeoposition")
    @State var locationHistory = UserDefaults.standard.object(forKey: "locationHistory") as? [String] ?? []
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack (alignment: .leading, spacing: 24) {
                HStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 32, height: 4)
                        .foregroundColor(Color(hex: "#646C75"))
                    Spacer()
                }
                .padding(.top, 8)
                
                Text("Choose location")
                    .foregroundColor(Color(hex: "#646C75"))
                    .font(.custom("Montserrat-SemiBold", size: 22))
//                    .padding(.top, 8)
                
                
                TextField("Input location", text: $location, onEditingChanged: { (isChangingName) in
                    if location.trimmingCharacters(in: .whitespaces).count > 0  && location.starts(with: " ") == false {
//                        UserDefaults.standard.set(chosenLocation.trimmingCharacters(in: .whitespaces), forKey: "username")
                    }
                }, onCommit: {
                    withAnimation {
                        if location.trimmingCharacters(in: .whitespaces).count > 0  && location.starts(with: " ") == false {
//                            UserDefaults.standard.set(chosenLocation.trimmingCharacters(in: .whitespaces), forKey: "username")
                        }
//                        isChangingName = false
                    }
                })
                    .textFieldStyle(CustomFieldStyle())
                    .multilineTextAlignment(.leading)
//                    .onReceive(Just(username)) { _ in limitText(textLimit) }
                

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.white)
                    HStack {
                        Text("Current geoposition")
                            .foregroundColor(Color(hex: "#646C75"))
                            .font(.custom("Montserrat-Medium", size: 14))
                        Spacer()
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
                    }
                    .padding(.horizontal, 16)
                }
                .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
                .frame(height: 56)
                .onTapGesture {
                    isGeoposition.toggle()
                    UserDefaults.standard.set(isGeoposition, forKey: "isGeoposition")
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
                                        if chosenLocation == locationHistory[item] {
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
                                }
                            }
                        }
                        .padding(16)
                    }
                }

            }
            .padding(.horizontal, 24)
        }
        .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
    }
}

struct ChooseLocationView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLocationView()
    }
}
