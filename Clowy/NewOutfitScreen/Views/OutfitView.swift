//
//  OutfitView.swift
//  Clowy
//
//  Created by Егор Карпухин on 26.04.2022.
//

import SwiftUI
import WaterfallGrid

struct OutfitView: View {
    @StateObject var viewModel = MainScreenViewModel.shared
    var outfit: [String]
    @State var isEditing: Bool?
//    @State var clothes: [Wardrobe] = []
    var delegate: WardrobeClothesCardCollectionDelegate?
    
//    private func getClothes() {
//        let resultClothes = CreateDefaultWardrobe.getClothes()
//        clothes = resultClothes
//    }
    
    func sortClothes(clothesList: [Cloth]) -> [Cloth] {
        let clothes = CreateDefaultWardrobe.getClothes()
        var sortedClothes: [Cloth] = []
        for clothesType in clothes {
            if let index = clothesList.firstIndex(where: {$0.type == clothesType.clothesTypeName} ) {
                sortedClothes.append(clothesList[index])
            }
        }
        return sortedClothes
    }
    
//    func addAddButton(list: [Cloth]) -> [Cloth] {
//        var addedList = list
//        addedList.append(Cloth(id: 1000, name: "", clothesType: .blank, temp: "", color: "", image: "Ok"))
//        return addedList
//    }
    
    var body: some View {
        if !outfit.isEmpty {
            let outfitItems = viewModel.getClothesByIds(outfit)
            let sortedOutfit = sortClothes(clothesList: outfitItems)
//            let finalOutfit = addAddButton(list: sortedOutfit)
            
            if sortedOutfit.isEmpty {
                WaterfallGrid(0..<4, id:\.self) { item in
                    MiniCardPlaceholder()
                }
                .gridStyle(columns: 4, spacing: 13)
                .padding(.bottom, 16)
                .padding(.horizontal, 24)
            } else {
//                if isEditing == true {
//                    WaterfallGrid(sortedOutfit) { item in
//                        MiniCard(cloth: item, delegate: delegate)
//                    }
//                    .padding(.horizontal)
//                    .gridStyle(columns: 4, spacing: 16)
//                } else {
                    WaterfallGrid(sortedOutfit) { item in
                        MiniCard(cloth: item, isEditing: isEditing, delegate: delegate)
                    }
                    .gridStyle(columns: 4, spacing: 13)
                    .padding(.bottom, 16)
                    .padding(.horizontal, 24)
//                }
            }
        }
    }
}

struct AddMiniCard {
    var image: String
    var isEditing = false
}
