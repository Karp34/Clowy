//
//  SwiftUIView.swift
//  Clowy
//
//  Created by Егор Карпухин on 23.12.2021.
//

import SwiftUI

//class WardrobeClothesCardCollectionViewModel: ObservableObject {
//    @Published var clothes: [Cloth] = []
//    @Published var orderTypes: [ClothesType] = []
//}

protocol WardrobeclothesCardCollectionDelegate {
    func appendToOutfit(cloth: Cloth)
}

struct WardrobeClothesCardCollection: View {
    
    var name: String
    var clothes: [Cloth]
    var selectedClothes: [Cloth]? = []
    var delegate: WardrobeclothesCardCollectionDelegate?
    
    
    @State var deletable: Bool = false
    
    var body: some View {
        let insets = EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        
        if selectedClothes != nil && selectedClothes!.count > 0{
            VStack (alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.custom("Montserrat-SemiBold", size: 22))
                    .padding(.leading, 24)
                    .foregroundColor(Color(hex: "#646C75"))
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(clothes) { cloth in
                            if selectedClothes!.contains(cloth) {
                                WardrobeClothesCard (cloth: cloth, selected: true)
                                    .onTapGesture {
                                        delegate!.appendToOutfit(cloth: cloth)
                                    }
                            } else {
                                WardrobeClothesCard (cloth: cloth, selected: false)
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
                            WardrobeClothesCard (cloth: cloth, deletable: deletable)
                        }
                        NewClothView()
                    }
                    .padding(insets)
                }
            }
        }
    }
}
