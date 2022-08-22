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
                    .padding(6)
            }
        } else {
            NoOutfit()
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
    }
}

struct NoOutfit : View {
    var body: some View {
        Text("Add more clothes!")
            .font(.custom("Montserrat-Regular", size: 14))
            .foregroundColor(Color(hex: "#606060"))
    }
}

struct MainClothesCard_Previews: PreviewProvider {
    static var previews: some View {
        ClothesCard(clothesName: "Черная шапка", clothesImage: "Cloth0")
            .previewDevice("iPhone 12 mini")
    }
}
