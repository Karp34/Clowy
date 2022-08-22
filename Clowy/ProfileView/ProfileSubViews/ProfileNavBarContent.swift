//
//  ProfileNavBarContent.swift
//  Clowy
//
//  Created by Егор Карпухин on 22.08.2022.
//

import SwiftUI

struct ProfileNavBarContent: View {
    @State var isChangingImage = false
    
    @State var isChangingName = false
    var color = "#CEDAE1"
    
    let hint = "Enter your name"
    @State var username = UserDefaults.standard.string(forKey: "username")!
    
    let insets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(Color(hex: "#678CD4"))
                .onTapGesture {
                    withAnimation {
                        isChangingName = false
                        isChangingImage = false
                    }
                }
            VStack {
                ZStack {
                    Circle()
                        .frame(width: isChangingName ? 96 : 72, height: isChangingName ? 96 : 72)
                        .foregroundColor(Color(hex: color))
                    Image("girl")
                        .resizable()
                        .scaledToFit()
                        .frame(width: isChangingName ? 85 : 68, height: isChangingName ? 85 : 68)
                }
                .padding(.top, isChangingName ? 56 : 8)
                .onTapGesture {
                    if isChangingName == false {
                        withAnimation {
                            isChangingImage.toggle()
                        }
                    }
                }
                if isChangingName == true {
                    VStack {
                        ZStack {
                            if username.count < 1 {
                                Text(hint)
                                    .foregroundColor(Color(hex: "##FFFFFF"))
                                    .multilineTextAlignment(.center)
                                    .opacity(0.5)
                                    .font(.custom("Montserrat-Semibold", size: 32))
                            }
                            TextField("", text: $username, onEditingChanged: { (isChangingName) in
                                UserDefaults.standard.set(username, forKey: "username")
                            }, onCommit: {
                                withAnimation {
                                    isChangingName = false
                                }
                            })
                                .textFieldStyle(CustomFieldStyle2())
                                .multilineTextAlignment(.center)
                        }
                        .padding(.horizontal)
                        .padding(.top, 83)
                        Spacer()
                    }
                } else {
                    Text(username)
                        .font(.custom("Montserrat-SemiBold", size: 20))
                        .foregroundColor(.white)
                        .padding(.bottom, 16)
                        .onTapGesture {
                            withAnimation {
                                isChangingName.toggle()
                            }
                        }
                }
            }
            
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
                .offset(y: 56)
                .padding(.horizontal, 24)
                .shadow(color: Color(hex: "#273145").opacity(0.2), radius: 35, x: 0, y: 8)
            }
        }
        .frame(height: isChangingName ? nil : 114)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ProfileNavBarContent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileNavBarContent()
    }
}