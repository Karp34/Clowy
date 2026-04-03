//
//  WardrobeModuleView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 14.04.2022.
//

import SwiftUI

struct WardrobeModuleView: View {
    @EnvironmentObject private var wardrobeViewModel: WardrobeViewModel
    @EnvironmentObject private var outfitViewModel: OutfitViewModel
    let color: Color
    let numberOfClothes: Int
    let numberOfOutfits: Int

    @State private var selection: Int? = nil

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            NavigationLink(destination: WardrobeView().environmentObject(wardrobeViewModel), tag: 1, selection: $selection) {
                Button {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { selection = 1 }
                } label: {
                    WardrobeButtonView(numberOfClothes: numberOfClothes, color: color)
                }
                .buttonStyle(NoAnimationButtonStyle())
            }
            .buttonStyle(ScaleButtonStyle())

            NavigationLink(destination: OutfitListView().environmentObject(outfitViewModel), tag: 2, selection: $selection) {
                Button {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { selection = 2 }
                } label: {
                    OutfitButtonView(numberOfOutfits: numberOfOutfits, color: color)
                }
                .buttonStyle(NoAnimationButtonStyle())
            }
            .buttonStyle(ScaleButtonStyle())

            AddNewClothButtonView()
        }
        .foregroundColor(.white)
        .shadow(color: Color.shadowGrey.opacity(0.1), radius: 35, y: 8)
    }
}

// MARK: - Outfit button

struct OutfitButtonView: View {
    let numberOfOutfits: Int
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).frame(idealWidth: 125, idealHeight: 136)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    ZStack {
                        Circle().frame(width: 28, height: 28).foregroundColor(color).opacity(0.2)
                        Image("Liked").foregroundColor(color).frame(width: 24, height: 24)
                    }
                    Spacer()
                }
                .padding(.top, 4)
                Text("\(numberOfOutfits)").font(.custom("Montserrat-Medium", size: 28)).foregroundColor(.black).padding(.top, 8)
                Text("My outfits").foregroundColor(.gray).font(.custom("Montserrat-Regular", size: 14))
            }
            .padding(.leading, 28)
        }
    }
}

// MARK: - Wardrobe button

struct WardrobeButtonView: View {
    let numberOfClothes: Int
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).frame(idealWidth: 125, idealHeight: 136)
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    ZStack(alignment: .center) {
                        Circle().frame(width: 28, height: 28).foregroundColor(color).opacity(0.2)
                        Image("Veshalka").frame(width: 28, height: 28).foregroundColor(color).padding(.bottom, 2)
                    }
                    Spacer()
                }
                .padding(.top, 4)
                Text("\(numberOfClothes)").font(.custom("Montserrat-Medium", size: 28)).foregroundColor(.black).padding(.top, 8)
                Text("In wardrobe").font(.custom("Montserrat-Regular", size: 14)).foregroundColor(.gray)
            }
            .padding(.leading, 28)
        }
    }
}

// MARK: - Add new cloth button

struct AddNewClothButtonView: View {
    @State private var isShowingSheet = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20).foregroundColor(.white)
            VStack {
                Button {
                    isShowingSheet = true
                } label: {
                    Image(systemName: "plus").padding().clipShape(Rectangle())
                }
                .sheet(isPresented: $isShowingSheet) {
                    CreateNewClothView(isShowingSheet: $isShowingSheet)
                }

                RoundedRectangle(cornerRadius: 2)
                    .frame(width: 40, height: 1)
                    .foregroundColor(.gray)
                    .opacity(0.2)

                NavigationLink(destination: CameraView().navigationBarHidden(true)) {
                    ZStack {
                        Image(systemName: "viewfinder").padding()
                        RoundedRectangle(cornerRadius: 2).frame(width: 8, height: 2).foregroundColor(.black)
                    }
                }
            }
            .foregroundColor(.black)
        }
        .frame(maxWidth: 61, idealHeight: 136)
    }
}
