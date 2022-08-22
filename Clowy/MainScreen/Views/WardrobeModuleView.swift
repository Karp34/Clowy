//
//  WardrobeModuleView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 14.04.2022.
//

import SwiftUI

struct WardrobeModuleView: View {
    var color: String
    
    var body: some View {
        HStack {
            WardrobeView(color: color)
            OutfitButtonView(color: color)
            AddNewClothView()
        }
        .foregroundColor(.white)
        .shadow(color: Color(hex: "#253445").opacity(0.1), radius: 35, y: 8)
    }
}

struct OutfitButtonView: View {
    var color: String
    var body: some View {
        if #available(iOS 14.0, *) {
            NavigationLink(destination: OutfitScreenView()
                .navigationBarTitle("My Outfits")
                .navigationBarTitleDisplayMode(.inline)
            ) {
                ZStack {
                    RoundedRectangle(cornerRadius:20)
                        .frame(height: 152.0)
                    VStack(alignment: .leading) {
                        HStack (alignment: .top) {
                            ZStack {
                                Circle()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(Color(hex: color))
                                    .opacity(0.2)
                                Image("Liked")
                                    .foregroundColor(Color(hex: color))
                                    .frame(width: 24, height: 24)
                                    .scaledToFill()
                            }
                            Spacer()
                        }
                        .padding(.top, 4)
                        Text("27")
                            .font(Font.custom("Montserrat-Medium", size: 28))
                            .foregroundColor(.black)
                            .padding(.top, 8)
                        Text("Your outfits")
                            .foregroundColor(.gray)
                            .font(Font.custom("Montserrat-Regular", size: 14))
                    }
                    .padding(.leading, 28)
                }
            }
        } else {
            NavigationLink(destination: OutfitScreenView()
                .navigationBarTitle("My Outfits")
            ) {
                ZStack {
                    RoundedRectangle(cornerRadius:20)
                        .frame(height: 152.0)
                    VStack(alignment: .leading) {
                        HStack (alignment: .top) {
                            ZStack {
                                Circle()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(Color(hex: color))
                                    .opacity(0.2)
                                Image("Liked")
                                    .foregroundColor(Color(hex: color))
                                    .frame(width: 24, height: 24)
                                    .scaledToFill()
                            }
                            Spacer()
                        }
                        .padding(.top, 4)
                        Text("27")
                            .font(Font.custom("Montserrat-Medium", size: 28))
                            .foregroundColor(.black)
                            .padding(.top, 8)
                        Text("Your outfits")
                            .foregroundColor(.gray)
                            .font(Font.custom("Montserrat-Regular", size: 14))
                    }
                    .padding(.leading, 28)
                }
            }
        }
    }
}

struct WardrobeView: View {
    
    var color: String
    var body: some View {
        if #available(iOS 14.0, *) {
            NavigationLink(
                destination: WardrobeCoreDataView()
                    .navigationBarTitle("Wardrobe")
                    .navigationBarTitleDisplayMode(.inline)
            ) {
                ZStack {
                    RoundedRectangle(cornerRadius:20)
                        .frame(height: 152.0)
                    VStack(alignment: .leading) {
                        HStack (alignment: .top) {
                            ZStack (alignment: .center){
                                Circle()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(Color(hex: color))
                                    .opacity(0.2)
                                Image("Veshalka")
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(Color(hex: color))
                                    .scaledToFill()
                                    .padding(.bottom, 2)
                            }
                            Spacer()
                        }
                        .padding(.top, 4)
                        Text("157")
                            .font(.custom("Montserrat-Medium", size: 28))
                            .foregroundColor(.black)
                            .padding(.top, 8)
                        Text("In wardrobe")
                            .font(.custom("Montserrat-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 28)
                }
            }
        } else {
            NavigationLink(
                destination: WardrobeCoreDataView()
            ) {
                ZStack {
                    RoundedRectangle(cornerRadius:20)
                        .frame(height: 152.0)
                    VStack(alignment: .leading) {
                        HStack (alignment: .top) {
                            ZStack (alignment: .center){
                                Circle()
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(Color(hex: color))
                                    .opacity(0.2)
                                Image("Veshalka")
                                    .frame(width: 28, height: 28)
                                    .foregroundColor(Color(hex: color))
                                    .scaledToFill()
                                    .padding(.bottom, 2)
                            }
                            Spacer()
                        }
                        .padding(.top, 4)
                        Text("157")
                            .font(.custom("Montserrat-Medium", size: 28))
                            .foregroundColor(.black)
                            .padding(.top, 8)
                        Text("In wardrobe")
                            .font(.custom("Montserrat-Regular", size: 14))
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 28)
                }
            }
        }
    }
}

struct AddNewClothView: View {
    @State private var isShowingSheet = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:20)
                .frame(width: 72.0, height: 152.0)
                .foregroundColor(.white)
            VStack{
                Button(action: {
                    isShowingSheet.toggle()
                }) {
                    Image(systemName: "plus")
                        .padding()
                }
                .sheet(isPresented: $isShowingSheet, onDismiss: didDismiss) {
                    VStack (spacing: 0) {
                        AddClothesView(isShowingSheet: $isShowingSheet)
//                        Button(action: {
//                            isShowingSheet.toggle()
//                        }) {
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 24)
//                                    .frame(height: 56)
//                                    .foregroundColor(Color(hex: "#CBCED2"))
//                                Text("SAVE")
//                                    .font(.custom("Montserrat-SemiBold", size: 16))
//                                    .foregroundColor(.white)
//                            }
//                        }
//                        .padding(.horizontal, 24)
//                        .padding(.bottom, 40)
                    }
                    .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
                }
                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 40.0, height: 1.0)
                    .foregroundColor(.gray)
                    .opacity(0.2)
                NavigationLink(
                    destination: CameraView()
                        .navigationBarHidden(true)
                ) {
                    ZStack {
                        Image(systemName: "viewfinder")
                            .padding()
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 8.0, height: 2.0)
                            .foregroundColor(.black)
                    }
                    
                }
            }
            .foregroundColor(.black)
        }
    }
    func didDismiss() {
        // Handle the dismissing action.
    }
}
