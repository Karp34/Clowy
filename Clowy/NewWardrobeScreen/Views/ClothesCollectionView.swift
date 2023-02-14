//
//  WardrobeClothesTestCardCollection.swift
//  Clowy
//
//  Created by Егор Карпухин on 29.06.2022.
//

import SwiftUI

protocol WardrobeClothesCardCollectionDelegate {
    func appendToOutfit(cloth: Cloth)
}

struct ClothesCollectionView: View {
    var name: String
    var clothes: [Cloth]
    var selectedClothes: [Cloth]? = []
    var delegate: WardrobeClothesCardCollectionDelegate?
    
    @State var deletable: Bool = false
    
    var body: some View {
        let insets = EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        
        if selectedClothes != nil && selectedClothes!.count > 0 {
            VStack (alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.custom("Montserrat-SemiBold", size: 22))
                    .padding(.leading, 24)
                    .foregroundColor(Color(hex: "#646C75"))
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(clothes) { cloth in
                            if selectedClothes!.contains(cloth) {
                                ClothesCardView(cloth: cloth, selected: true)
                                    .onTapGesture {
                                        delegate!.appendToOutfit(cloth: cloth)
                                    }
                            } else {
                                ClothesCardView(cloth: cloth, selected: false)
                                    .onTapGesture {
                                        delegate!.appendToOutfit(cloth: cloth)
                                    }
                            }
                        }
                        NewClothView()
                    }
                    .padding(insets)
                }
            }
        } else {
            VStack (alignment: .leading, spacing: 0) {
                HStack {
                    Text(name)
                        .font(.custom("Montserrat-SemiBold", size: 22))
                        .padding(.leading, 24)
                        .foregroundColor(Color(hex: "#646C75"))
                    Spacer()
                    Image("Edit")
                        .resizable()
                        .foregroundColor(Color(hex: "#646C75"))
                        .frame(width: 16, height: 16)
                        .scaledToFit()
                        .padding(.trailing,16)
                        .onTapGesture {
                            deletable.toggle()
                        }
                }
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(clothes) { cloth in
                            ClothesCardView(cloth: cloth, deletable: deletable)
                        }
                        NewClothView()
                    }
                    .padding(insets)
                }
            }
        }
    }
}
