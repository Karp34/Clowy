//
//  WardrobeModuleView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 14.04.2022.
//

import SwiftUI

struct WardrobeModuleView: View {
    var color: String
    var numberOfClothes: Int
    var numberOfOutfits: Int
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            WardrobeView(numberOfClothes: numberOfClothes, color: color)
            OutfitButtonView(numberOfOutfits: numberOfOutfits, color: color)
            AddNewClothView()
        }
        .foregroundColor(.white)
        .shadow(color: Color(hex: "#253445").opacity(0.1), radius: 35, y: 8)
    }
}

struct OutfitButtonView: View {
    var numberOfOutfits: Int
    var color: String
    var body: some View {
        NavigationLink(destination: OutfitScreenView()
            .navigationBarTitle("My Outfits")
            .navigationBarTitleDisplayMode(.inline)
        ) {
            ZStack {
                RoundedRectangle(cornerRadius:20)
                    .frame(idealWidth: 125, idealHeight: 136)
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
                    
                    Text(String(numberOfOutfits))
                        .font(Font.custom("Montserrat-Medium", size: 28))
                        .foregroundColor(.black)
                        .padding(.top, 8)
                    Text("My outfits")
                        .foregroundColor(.gray)
                        .font(Font.custom("Montserrat-Regular", size: 14))
                }
                .padding(.leading, 28)
            }
        }
    }
}

struct WardrobeView: View {
    var numberOfClothes: Int
    var color: String
    var body: some View {
        NavigationLink(
            destination: WardrobeCoreDataView()
                .navigationBarTitle("Wardrobe")
                .navigationBarTitleDisplayMode(.inline)
        ) {
            ZStack {
                RoundedRectangle(cornerRadius:20)
                    .frame(idealWidth: 125, idealHeight: 136)
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
                    Text(String(numberOfClothes))
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

struct AddNewClothView: View {
    @State private var isShowingSheet = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius:20)
                .frame(maxWidth: 61, idealHeight: 136)
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
    }
}
