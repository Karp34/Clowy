////
////  OutfitView.swift
////  Clowy
////
////  Created by Егор Карпухин on 26.04.2022.
////
//
//import SwiftUI
//import WaterfallGrid
//
//struct OutfitView: View {
//    var outfit: [Cloth]
//    @State var isEditing: Bool?
//    @State var clothes: [Wardrobe] = []
//    var delegate: WardrobeclothesCardCollectionDelegate?
//    
//    private func getClothes() {
//        let resultClothes = GetClothes.getClothes()
//        clothes = resultClothes
//    }
//    
//    func sortClothes(clothesList: [Cloth]) -> [Cloth] {
//        var sortedClothes: [Cloth] = []
//        for clothesType in clothes {
//            if let index = clothesList.firstIndex(where: {$0.clothesType == clothesType.clothesTypeName} ) {
//                sortedClothes.append(clothesList[index])
//            }
//        }
//        return sortedClothes
//    }
//    
////    func addAddButton(list: [Cloth]) -> [Cloth] {
////        var addedList = list
////        addedList.append(Cloth(id: 1000, name: "", clothesType: .blank, temp: "", color: "", image: "Ok"))
////        return addedList
////    }
//    
//    var body: some View {
//        if !outfit.isEmpty {
//            let sortedOutfit = sortClothes(clothesList: outfit)
////            let finalOutfit = addAddButton(list: sortedOutfit)
//            if isEditing == true {
//                WaterfallGrid(sortedOutfit) { item in
//                    MiniCard(cloth: item, delegate: delegate)
//                }
//                .padding(.horizontal)
//                .gridStyle(columns: 4, spacing: 16)
//                .onAppear() {
//                    getClothes()
//                }
//            } else {
//                WaterfallGrid(sortedOutfit) { item in
//                    MiniCard(cloth: item, isEditing: false, delegate: delegate)
//                }
//                .padding(.horizontal)
//                .gridStyle(columns: 4, spacing: 16)
//                .onAppear() {
//                    getClothes()
//                }
//            }
//        }
//    }
//}
//
//struct AddMiniCard {
//    var image: String
//    var isEditing = false
//}
//
////struct OutfitView_Preview: PreviewProvider {
////    static var previews: some View {
////        OutfitView()
////    }
////}
