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
    @StateObject private var viewModel = MainScreenViewModel.shared
    @StateObject private var addClothesViewModel = AddClothesViewModel.shared
    var clothesTypeName: ClothesType
    var clothes: [Cloth]
    var selectedClothes: [Cloth]? = []
    var delegate: WardrobeClothesCardCollectionDelegate?
    @State var editableCloth: Cloth?
    
    @State private var showingAlert = false
    @State private var isShowingSheet = false
    @State private var isShowingSheetAdd = false
    
    
    
    
    
    var menuItems: some View {
        return Group {
            Button {
                isShowingSheet.toggle()
                if let editableCloth {
                    addClothesViewModel.cloth = editableCloth
                    addClothesViewModel.temp = GetTemperatureRange.decodeTemperature(listTemp: editableCloth.temperature)
                }
                
            } label: {
                Label("Edit", systemImage: "square.and.pencil")
            }
            
            Button {
                showingAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
                    .tint(.red)
            }
        }
    }
    
    @State var deletable: Bool = false
    
    var body: some View {
        let insets = EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
        let sortedClothes = clothes.sorted { $0.creationDate < $1.creationDate }
        
        if selectedClothes != nil && selectedClothes!.count > 0 {
            VStack (alignment: .leading, spacing: 0) {
                Text(clothesTypeName.rawValue)
                    .font(.custom("Montserrat-SemiBold", size: 22))
                    .padding(.leading, 24)
                    .foregroundColor(Color(hex: "#646C75"))
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(sortedClothes) { cloth in
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
                    Text(clothesTypeName.rawValue)
                        .font(.custom("Montserrat-SemiBold", size: 22))
                        .padding(.leading, 24)
                        .foregroundColor(Color(hex: "#646C75"))
                    if !clothes.isEmpty {
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
                }
                ScrollView (.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(sortedClothes) { cloth in
                            ClothesCardView(cloth: cloth, deletable: deletable)
                                .sheet(isPresented: $isShowingSheet, onDismiss: addClothesViewModel.reset) {
                                    AddClothesView(isEdtitngCloth: true, isShowingSheet: $isShowingSheet)
                                }
                                .contextMenu {
                                    menuItems
                                        .onAppear {
                                            editableCloth = cloth
                                        }
                                }
                                .alert(isPresented: $showingAlert) {
                                    Alert(
                                        title: Text("Delete cloth"),
                                        message: Text("Do you want to delete this cloth?"),
                                        primaryButton:  .default(Text("No")) {
                                            print("No")
                                        },
                                        secondaryButton:  .default(Text("Yes")){
                                            print("Yes")
                                            viewModel.deleteCloth(cloth: editableCloth!)
                                        }
                                    )
                                }
                                
                        }
                        NewClothView()
                            .onTapGesture {
                                addClothesViewModel.cloth.type = clothesTypeName
                                isShowingSheetAdd.toggle()
                            }
                            .sheet(isPresented: $isShowingSheetAdd, onDismiss: addClothesViewModel.reset) {
                                AddClothesView(isEdtitngCloth: false, isShowingSheet: $isShowingSheet)
                            }
                    }
                    .padding(insets)
                }
            }
        }
    }
}
