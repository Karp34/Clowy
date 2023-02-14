////
////  WardrobeClothesTestCardCollection.swift
////  Clowy
////
////  Created by Егор Карпухин on 29.06.2022.
////
//
//import SwiftUI
//
//protocol WardrobeClothesTestCardCollectionDelegate {
//    func appendToOutfit(cloth: Cloth)
//}
//
//struct WardrobeClothesTestCardCollection: View {
//    
//    var name: String
//    var clothes: [TestCloth]
//    var selectedClothes: [TestCloth]? = []
//    var delegate: WardrobeClothesTestCardCollectionDelegate?
//    
//    
//    @State var deletable: Bool = false
//    
//    var body: some View {
//        let insets = EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
//        
//        if selectedClothes != nil && selectedClothes!.count > 0 {
//            VStack (alignment: .leading, spacing: 0) {
//                Text(name)
//                    .font(.custom("Montserrat-SemiBold", size: 22))
//                    .padding(.leading, 24)
//                    .foregroundColor(Color(hex: "#646C75"))
//                ScrollView (.horizontal, showsIndicators: false) {
//                    HStack {
//                        ForEach(clothes) { cloth in
//                            if selectedClothes!.contains(cloth) {
//                                WardrobeTestClothCard (cloth: cloth, selected: true)
//                            }
//                        }
//                        NewClothView()
//                    }
//                    .padding(insets)
//                }
//            }
//        } else {
//            VStack (alignment: .leading, spacing: 0) {
//                HStack {
//                    Text(name)
//                        .font(.custom("Montserrat-SemiBold", size: 22))
//                        .padding(.leading, 24)
//                        .foregroundColor(Color(hex: "#646C75"))
//                    Spacer()
//                    Image("Edit")
//                        .resizable()
//                        .foregroundColor(Color(hex: "#646C75"))
//                        .frame(width: 16, height: 16)
//                        .scaledToFit()
//                        .padding(.trailing,16)
//                        .onTapGesture {
//                            deletable.toggle()
//                        }
//                }
//                ScrollView (.horizontal, showsIndicators: false) {
//                    HStack {
//                        ForEach(clothes) { cloth in
//                            WardrobeTestClothCard (cloth: cloth, deletable: deletable)
//                        }
//                        NewClothView()
//                    }
//                    .padding(insets)
//                }
//            }
//        }
//    }
//}
