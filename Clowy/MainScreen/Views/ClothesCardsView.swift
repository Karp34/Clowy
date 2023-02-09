//
//  ClothesCardsView.swift
//  Clowy2
//
//  Created by Егор Карпухин on 19.04.2022.
//

import SwiftUI
import WaterfallGrid


struct ClothesCardsView: View {
    
    func getRatio(name: ClothesType) -> Double {
        let clothes = GetClothes.getClothes()
        var output = 0.85
        for cloth in clothes {
            if name == cloth.clothesTypeName {
                output = cloth.ratio.rawValue
            }
        }
        return output
    }
    
    var outfit: [Cloth]
    
    var body: some View {
        if !outfit.isEmpty {
            WaterfallGrid(outfit) { item in
                ClothesCard(clothesName: item.name, clothesImage: item.image)
                    .aspectRatio(getRatio(name: item.clothesType), contentMode: .fit)
            }
            .padding(.horizontal, 4)
        } else {
            NoOutfit()
                .padding(.horizontal, 8)
        }
        
    }
}

struct ClothesCard: View {
    @State var clothesName: String
    @State var clothesImage: String

    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            VStack (spacing: 12){
                Image(clothesImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 100)
                Text(clothesName)
                    .font(.custom("Montserrat-Regular", size: 14))
                    .multilineTextAlignment(.center)
                    .frame(width: 120)
                    .scaledToFill()
                    .foregroundColor(Color(hex: "#606060"))
                
            }
            .padding()
        }
        .shadow(color:Color(hex: "#646C75").opacity(0.15), radius: 30, y: 4)
        .padding(4)
    }
}

struct NoOutfit : View {
    @StateObject private var viewModel = MainScreenViewModel.shared
    @State var isShowingSheet = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .frame(width: 96, height: 96)
                    .foregroundColor(Color(hex: viewModel.chosenWeather.color)).opacity(0.2)
                Image("Veshalka")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 41)
                    .foregroundColor(Color(hex: viewModel.chosenWeather.color))
            }
            Text("No items in wardrobe")
                .font(.custom("Montserrat-SemiBold", size: 20))
                .foregroundColor(Color(hex: "#646C75"))
                .multilineTextAlignment(.center)
        }
        .frame(idealHeight: 320)
        
        Button {
            isShowingSheet.toggle()
        } label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                Text("Add")
                    .font(.custom("Montserrat-Bold", size: 24))
                    .foregroundColor(.white)
            }
            
        }
        .padding(.bottom, 24)
        .buttonStyle(DefaultColorButtonStyle(color: viewModel.chosenWeather.color, radius: 24))
        .sheet(isPresented: $isShowingSheet) {
            VStack (spacing: 0) {
                AddClothesView(isShowingSheet: $isShowingSheet)
            }
            .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
        }
    }
}

struct MainClothesCard_Previews: PreviewProvider {
    static var previews: some View {
        ClothesCard(clothesName: "Черная шапка", clothesImage: "Cloth0")
            .previewDevice("iPhone 12 mini")
    }
}
