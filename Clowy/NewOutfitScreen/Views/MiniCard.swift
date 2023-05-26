//
//  MiniCardView.swift
//  Clowy
//
//  Created by Егор Карпухин on 27.04.2022.
//

import SwiftUI


struct MiniCard: View {
    var cloth: Cloth
    @State var isEditing: Bool? = true
    var defaultNames: [String] = ["DefaultUpperWear", "DefaultPants", "DefaultSneaker"]
    var delegate: WardrobeClothesCardCollectionDelegate?
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
//                .frame(width: 80, height: 80)
                .aspectRatio(1/1, contentMode: .fill)
            if defaultNames.contains(cloth.image){
                Image(cloth.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .foregroundColor(Color(hex: "#678CD4"))
            } else {
                ClothImage(imageName: cloth.image, isDeafult: cloth.isDefault, color: cloth.color)
                    .scaledToFit()
//                    .frame(width: 65, height: 65)
                    .padding(8)
                if isEditing == true {
                    HStack {
                        Spacer()
                        VStack{
                            Image(systemName: "xmark")
                                .resizable()
                                .foregroundColor(Color(hex: "#646C75"))
                                .frame(width: 8, height: 8)
                                .scaledToFit()
                                .padding(8)
                                .background(Color.clear).frame(width: 30, height: 30)
                            Spacer()
                        }
                    }
//                    .frame(width: 80, height: 80)
                    .aspectRatio(1/1, contentMode: .fill)
                    
                }
            }
        }
        .frame(maxWidth: 80, maxHeight: 80)
        .onTapGesture {
            delegate?.appendToOutfit(cloth: cloth)
        }
        .shadow(color:Color(hex: "#646C75").opacity(0.1), radius: 30, y: 4)
    }
}
