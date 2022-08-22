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
    @State var isChangingName = false
    
    let hint = "Enter your name"
    @State var username = UserDefaults.standard.string(forKey: "username")!
    
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
