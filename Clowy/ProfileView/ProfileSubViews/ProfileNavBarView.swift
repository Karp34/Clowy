//
//  ProfileNavBarView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI


struct ProfileNavBarView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: ProfileViewModel
    
    var btnBack : some View {
        Button (action: {
            self.presentationMode.wrappedValue.dismiss()}) {
                ZStack {
                    Image("back_button")
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12.0, height: 12.0)
                        .foregroundColor(.white)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 20, height: 25)
                }
            }
    }
    
    @State var gender = UserDefaults.standard.string(forKey: "gender") ?? "female"
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
                                    UserDefaults.standard.set( GetChosenClothes.getChosenClothes()[ gender == "male" ? 0 : 1 ].clothes, forKey: "chosenClothesTypes")
                                    viewModel.chosenClothes = GetChosenClothes.getChosenClothes()[ gender == "male" ? 0 : 1 ].clothes
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
