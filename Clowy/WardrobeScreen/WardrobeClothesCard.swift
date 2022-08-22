//
//  WardrobeClothesCard.swift
//  Clowy
//
//  Created by Егор Карпухин on 23.12.2021.
//

import SwiftUI

struct WardrobeClothesCard: View {
    @State var cloth: Cloth
    var selected: Bool? = false
    var deletable: Bool? = false
    
    @State private var showingAlert = false

    var body: some View {
            ZStack {
                if selected == true {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.white)
//                            .frame(width: 128, height: 164)
                        HStack {
                            Spacer()
                            VStack{
                                ZStack {
                                    Circle()
                                        .foregroundColor(.green)
                                        .frame(width: 24, height: 24)
                                    Image("Ok")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 14, height: 12)
                                }
                                .padding(8)
                                Spacer()
                            }
                        }
                    }
                    .frame(width: 128, height: 164)
                } else if deletable == true {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.white)
                        HStack {
                            Spacer()
                            VStack{
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                                    .frame(width: 24, height: 24)
                                    .padding(8)
                                Spacer()
                            }
                        }
                        .onTapGesture {
                            showingAlert = true
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(
                                title: Text("Delete cloth"),
                                message: Text("Do you want to delete this cloth?"),
                                primaryButton:  .default(Text("No")) {
                                    print("No")
                                },
                                secondaryButton:  .default(Text("Yes")){
                                    print("Yes")                                }
                            )
                        }
                    }
                    .frame(width: 128, height: 164)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.white)
                        .frame(width: 128, height: 164)
                }
                VStack{
                    Image(cloth.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 100)
                    Text(cloth.name)
                        .font(.custom("Montserrat-Regular", size: 14))
                        .multilineTextAlignment(.center)
                        .frame(width: 100)
                        .scaledToFill()
                        .padding(.vertical, 2)
                        .foregroundColor(Color(hex: "#606060"))
                }
                .padding()
        }
            .shadow(color:Color(hex: "#646C75").opacity(0.1), radius: 10, y: 4)
    }
}
