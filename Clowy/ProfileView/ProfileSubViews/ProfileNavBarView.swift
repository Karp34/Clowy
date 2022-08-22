//
//  ProfileNavBarView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI

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
    
    @State var isChangingGender = false
    
    var btnChangeGender: some View {
        ZStack {
            if isChangingGender == true {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 98)
                HStack(spacing:0){
                    Image("plus")
                        .foregroundColor(Color(hex: "#DE8FD6"))
                        .frame(width: 32)
                    Rectangle()
                        .frame(width: 1, height: 16)
                        .foregroundColor(Color(hex: "#DBE4EF"))
                    Image("plus")
                        .foregroundColor(Color(hex: "#DE8FD6"))
                        .frame(width: 32)
                    Rectangle()
                        .frame(width: 1, height: 16)
                        .foregroundColor(Color(hex: "#DBE4EF"))
                    Image("plus")
                        .foregroundColor(Color(hex: "#DE8FD6"))
                        .frame(width: 32)
                }
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 32)
                Image("plus")
                    .foregroundColor(Color(hex: "#DE8FD6"))
            }
        }
        .frame(height: 32)
        .foregroundColor(.white)
        .onTapGesture {
            isChangingGender.toggle()
        }
    }
        
    
    var color = "#CEDAE1"
    var name = "Madeline"
    
    @State var isChangingImage = false
    
    let insets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
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
                    
                    ZStack {
                        Circle()
                            .frame(width: 72, height: 72)
                            .foregroundColor(Color(hex: color))
    //                        .opacity(0.2)
                        Image("girl")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 68, height: 68)
                    }
                    .onTapGesture {
                        isChangingImage.toggle()
                    }
                        
                    Text(name)
                        .font(.custom("Montserrat-SemiBold", size: 20))
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                }
            }
            .frame(height: 180)
            .foregroundColor(Color(hex: "#678CD4"))
            .background(Color(hex: "#678CD4").frame(height: 80).edgesIgnoringSafeArea(.all).offset(y: -100))
            
            if isChangingImage == true {
                ZStack {
                    Rectangle()
                        .frame(width: 11, height: 11)
                        .foregroundColor(.white)
                        .rotationEffect(Angle.degrees(45))
                        .padding(.bottom, 60)
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(height: 64)
                            .foregroundColor(.white)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack (spacing: 8) {
                                ZStack {
                                    Circle()
                                        .frame(width: 40, height: 40)
                                        .foregroundColor(Color(hex: "#E1E8F6"))
                                    Image(systemName: "camera.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 18)
                                        .foregroundColor(Color(hex: "#678CD4"))
                                }
                                ForEach (0..<10) { id in
                                    ZStack {
                                        Circle()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(Color(hex: "#B4E5BC"))
                                        Image("girl")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 32, height: 32)
                                    }
                                    
                                }
                            }
                            .padding(insets)
                        }
                    }
                    
                }
                .offset(y: 76)
                .padding(.horizontal, 24)
                .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
            }
        }
        
    }
}
