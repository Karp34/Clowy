//
//  ProfileNavBarView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI

struct Gender {
    var icon: String
    var color: genderColor
}

enum genderColor: String {
    case male = "#5bcefa"
    case female = "#f5a9b8"
    case transgender = "#FFBF00"
}

struct ProfileNavBarView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var btnBack : some View {
        Button (action: {
            self.presentationMode.wrappedValue.dismiss()}) {
                Image("back_button")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12.0, height: 12.0).contentShape(Rectangle())
                    .foregroundColor(.white)
            }
    }
    
    @State var gender = UserDefaults.standard.string(forKey: "gender")!
    @State var isChangingGender = false
    @State var isChangingName = false
    
    let hint = "Enter your name"
    
    let genderList: [Gender] = [Gender(icon: "male", color: .male), Gender(icon: "female", color: .female), Gender(icon: "transgender", color: .transgender)]
    
    var btnChangeGender: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(width: isChangingGender ? 98 : 32 )
            if isChangingGender == true {
                HStack(spacing : 6) {
                    ForEach (0..<3) { id in
                        Image(genderList[id].icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(Color(hex: genderList[id].color.rawValue))
                            .onTapGesture {
                                withAnimation {
                                    gender = genderList[id].icon
                                    UserDefaults.standard.set(gender, forKey: "gender")
                                    isChangingGender = false
                                }
                            }
                        if id < 2 {
                            Rectangle()
                                .frame(width: 1, height: 16)
                                .foregroundColor(Color(hex: "#DBE4EF"))
                        }
                    }
                }
            } else {
                let index = genderList.firstIndex(where: {$0.icon == gender })
                Image(gender)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Color(hex: genderList[index!].color.rawValue))
                    .onTapGesture {
                        withAnimation {
                            isChangingGender = true
                        }
                    }
            }
        }
        .frame(height: 32)
        .foregroundColor(.white)
    }
    
    let insets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                HStack {
                    btnBack
                    Spacer()
                }
                .frame(width: 120)
                Spacer()
                Text("Profile")
                    .font(.custom("Montserrat-Bold", size: 14))
                    .foregroundColor(.white)
                Spacer()
                HStack {
                    Spacer()
                    btnChangeGender
                }
                .frame(width: 120)
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
        }
        
        .foregroundColor(Color(hex: "#678CD4"))
        .background(Color(hex: "#678CD4")
            .frame(height: 124)
            .edgesIgnoringSafeArea(.all)
            .offset(y: -20))
                    
//                 
        
    }
}
