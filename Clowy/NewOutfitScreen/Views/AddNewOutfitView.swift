//
//  AddNewOutfitView.swift
//  Clowy
//
//  Created by Егор Карпухин on 27.04.2022.
//

import SwiftUI
import Firebase
import Foundation

class AddNewOutfitViewModel: ObservableObject, WardrobeClothesCardCollectionDelegate {
    @StateObject var mainViewModel = MainScreenViewModel.shared
    @Published var isSavingOutfit = false
    @Published var newOutfitName: String = ""
    @Published var showSaveButton: Bool = false
    
    @Published var defaultStringOutfit = ["1100","1101","1102"]
    @Published var defaultOutfit = [
        Cloth(id: "1100", name: "", type: .tshirts, color: "#000000", temperature: ["Cold"], isDefault: true, image: "DefaultUpperWear"),
        Cloth(id: "1101", name: "", type: .pants, color: "#000000", temperature: ["Cold"], isDefault: true, image: "DefaultPants"),
        Cloth(id: "1102", name: "", type: .sneakers, color: "#00000", temperature: ["Cold"], isDefault: true, image: "DefaultSneaker")
    ]
    
    func appendToOutfit(cloth: Cloth) {
        let defaulClothesType = [
            Cloth(id: "1100", name: "", type: .tshirts, color: "#000000", temperature: ["Cold"], isDefault: true, image: "DefaultUpperWear"),
            Cloth(id: "1101", name: "", type: .pants, color: "#000000", temperature: ["Cold"], isDefault: true, image: "DefaultPants"),
            Cloth(id: "1102", name: "", type: .sneakers, color: "#00000", temperature: ["Cold"], isDefault: true, image: "DefaultSneaker")
        ]
        
        let upperClothesTypes = [ClothesType.hoodies, ClothesType.jackets, ClothesType.thermals, ClothesType.tshirts, ClothesType.dresses]
        let lowerClothesTypes = [ClothesType.pants, ClothesType.skirts, ClothesType.dresses]
        
        
        if !defaultOutfit.contains(cloth) {
            if let index = defaultOutfit.firstIndex(where: {$0.type == cloth.type }) {
                // если есть такой же тип, удаляет заглушку
                defaultOutfit.remove(at: (index))
            }
            else if upperClothesTypes.contains(cloth.type) {
                // если у вещи тип одежды верх, то удаляет заглушку верха
                if let index = defaultOutfit.firstIndex(where: {$0.id == "1100"}) {
                    defaultOutfit.remove(at: (index))
                }
                
                if lowerClothesTypes.contains(cloth.type) {
                    if let index = defaultOutfit.firstIndex(where: {$0.id == "1101"}) {
                        defaultOutfit.remove(at: (index))
                    }
                }
            }
            else if lowerClothesTypes.contains(cloth.type) {
                if let index = defaultOutfit.firstIndex(where: {$0.id == "1101"}) {
                    defaultOutfit.remove(at: (index))
                }
            }
            defaultOutfit.append(cloth)
        } else {
            let index = defaultOutfit.firstIndex(where: {$0.type == cloth.type })
            defaultOutfit.remove(at: (index)!)
            
            var outfitTypes = [ClothesType]()
            for id in defaultOutfit {
                outfitTypes.append(id.type)
            }
            
//          проверяем наличие всех обязательных вещей и добавляем заглушки если нет
            for cloth in defaulClothesType {
                if cloth.id == "1100" {
                    if !defaultOutfit.contains(cloth) && !outfitTypes.contains(cloth.type) {
                        var hasUpperType = false
                        for type in outfitTypes {
                            if upperClothesTypes.first(where: {$0 == type}) != nil {
                                hasUpperType = true
                            }
                        }
                        if !hasUpperType {
                            defaultOutfit.append(cloth)
                        }
                    }
                }
                
                if cloth.id == "1101" {
                    if !defaultOutfit.contains(cloth) && !outfitTypes.contains(cloth.type) {
                        var hasLowerType = false
                        for type in outfitTypes {
                            if lowerClothesTypes.first(where: {$0 == type}) != nil {
                                hasLowerType = true
                            }
                        }
                        if !hasLowerType {
                            defaultOutfit.append(cloth)
                        }
                    }
                }
                
                if cloth.id == "1102" {
                    if !defaultOutfit.contains(cloth) && !outfitTypes.contains(cloth.type) {
                        defaultOutfit.append(cloth)
                    }
                }
            }
        }
        
        var contains = false
        for item in defaulClothesType {
            if defaultOutfit.contains(item) {
                contains = true
            }
        }
        
        defaultStringOutfit.removeAll()
        for item in defaultOutfit {
            defaultStringOutfit.append(item.id)
        }
        showSaveButton = !contains
    }
    
    func addOutfit(clothes: [String], isGenerated: Bool, name: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(mainViewModel.userId).collection("Outfits")
        let timeInterval = NSDate().timeIntervalSince1970
        ref.addDocument(data: ["clothes": clothes, "isGenerated": isGenerated, "name" : name, "createDTM" : timeInterval]) { error in
            if error == nil {
                self.mainViewModel.outfits.append(Outfit(id: UUID().uuidString, name: name, isGenerated: isGenerated, clothes: clothes, createDTM: timeInterval))
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func reset() {
        isSavingOutfit = false
        newOutfitName = ""
        showSaveButton = false
        defaultStringOutfit = ["1100","1101","1102"]
        defaultOutfit = [
            Cloth(id: "1100", name: "", type: .tshirts, color: "#000000", temperature: ["Cold"], isDefault: true, image: "DefaultUpperWear"),
            Cloth(id: "1101", name: "", type: .pants, color: "#000000", temperature: ["Cold"], isDefault: true, image: "DefaultPants"),
            Cloth(id: "1102", name: "", type: .sneakers, color: "#00000", temperature: ["Cold"], isDefault: true, image: "DefaultSneaker")
        ]
    }
    
    static var shared = AddNewOutfitViewModel()
}



struct AddNewOutfitView: View{
    @StateObject var outfitViewModel = AddNewOutfitViewModel.shared
    @StateObject var viewModel = MainScreenViewModel.shared
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var outfit: [Cloth] = []
    @State var isEditing: Bool = true
    @State var isEditingName: Bool = false
    
    var newOutfit: [Cloth]?
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 8) {
                VStack (alignment: .leading, spacing: 0) {
                    NewOutfitNavBar()
                    OutfitView(outfit: outfitViewModel.defaultStringOutfit, isEditing: isEditing, delegate: outfitViewModel)
                }
                    
                CustomSheetView(radius: 32, color: "#F7F8FA", clearCornerColor: "#6286C9", topLeftCorner: true, topRightCorner: false) {
                    ScrollView  (.vertical, showsIndicators: false) {
                        Spacer(minLength: 24)
                        if viewModel.wardrobe.isEmpty {
                            NewWardrobeScreenPlaceholder()
                        } else {
                            VStack {
                                ForEach(viewModel.wardrobe) { cat in
                                    if cat.items.count > 0 {
                                        ClothesCollectionView(clothesTypeName: cat.clothesTypeName, clothes: cat.items, selectedClothes: outfitViewModel.defaultOutfit, delegate: outfitViewModel.self)
                                    } else {
                                        NoClothesCollection(name: cat.clothesTypeName.rawValue)
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }.background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
            }
            .navigationBarHidden(true)
            .onAppear() {
//                viewModel.fetchWardrobe()
                outfitViewModel.defaultOutfit = newOutfit ?? outfitViewModel.defaultOutfit
            }
            .background(Color(hex: "#6286C9").edgesIgnoringSafeArea(.all))
            
            if outfitViewModel.isSavingOutfit {
                VStack(spacing: 0) {
                    Rectangle()
                        .foregroundColor(.white).opacity(0.01)
                        .onTapGesture {
                            withAnimation {
                                outfitViewModel.isSavingOutfit = false
                                isEditingName = false
                            }
                        }
                    CustomSheetView(radius: 32, color: "#FFFFFF", clearCornerColor: "#CCCCCCCC", topLeftCorner: true, topRightCorner: true) {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Create outfit")
                                .font(.custom("Montserrat-SemiBold", size: 22))
                                .foregroundColor(Color(hex: "#646C75"))
                                .padding(.top, 24)
                                .padding(.bottom, 12)
                            
                            HStack (alignment: .top) {
                                ZStack(alignment: .leading) {
                                    TextField("Outfit name", text: $outfitViewModel.newOutfitName, onEditingChanged: { changed in
                                        withAnimation {
                                            isEditingName = changed
                                        }
                                      })
                                        .textFieldStyle(CustomFieldStyle())
                                }
                                Spacer()
                                if outfitViewModel.newOutfitName.count > 2 {
                                    ZStack{
                                        Circle()
                                            .frame(width: 18, height: 18)
                                            .foregroundColor(Color(hex: "#79D858"))
                                        Image("Ok")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 10, height: 10)
                                            .foregroundColor(Color(hex: "##FFFFFF"))
                                    }
                                }
                            }
                            .padding(.bottom, 2)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color(hex: "#DADADA"))
                                .padding(.bottom, 32)
                            
                            Button {
                                outfitViewModel.addOutfit(clothes: outfitViewModel.defaultStringOutfit, isGenerated: false, name: outfitViewModel.newOutfitName)
                                self.presentationMode.wrappedValue.dismiss()
                                outfitViewModel.reset()
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 24)
                                        .frame(height: 56)
                                        .foregroundColor(.clear)
                                    Text("SAVE")
                                        .font(.custom("Montserrat-SemiBold", size: 16))
                                        .foregroundColor(.white)
                                }
                            }
                            .buttonStyle(DefaultColorButtonStyle(color: "#678CD4", radius: 24))
                            .disabled(outfitViewModel.newOutfitName.count < 2)
                            .padding(.bottom, 40)
                            Spacer(minLength: 1)
                            
                        }
                        .padding(.horizontal, 24)
                    }
                    .frame(height: isEditingName ? 609 : 250)
                }
                .background(Color(hex: "#CCCCCCCC"))
                .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            if !outfit.isEmpty {
                outfitViewModel.reset()
                for cloth in outfit {
                    outfitViewModel.appendToOutfit(cloth: cloth)
                }
            }
        }
    }
}


struct OutfitWardrobeView: View {
    
    var delegate: WardrobeClothesCardCollectionDelegate
    var clothesTypeName: ClothesType
    var clothList: [Cloth]
    var defaultOutfit: [Cloth]
    
    
    
    var body: some View {
        if !clothList.isEmpty {
            ClothesCollectionView(clothesTypeName: clothesTypeName, clothes: clothList, selectedClothes: defaultOutfit, delegate: delegate)
        } else {
            NoClothesCollection(name: clothesTypeName.rawValue)
        }
    }
}

struct NewOutfitNavBar: View {
    @StateObject var viewModel = AddNewOutfitViewModel.shared
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var isShowingSheet = false
    
    var btnBack : some View {
        Button (action: {
            self.presentationMode.wrappedValue.dismiss()}) {
                Image("back_button")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 12.0, height: 12.0).contentShape(Rectangle())
                    .foregroundColor(.white)
            }
    }
    
    var btnSave : some View {
        Button(action: {
            withAnimation {
                viewModel.isSavingOutfit = true
            }
        }) {
            ZStack{
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color(hex: "#7CA8FF"))
                    .frame(width: 64, height: 32)
                Text("SAVE")
                    .foregroundColor(.white)
                    .font(.custom("Montserrat-Bold", size: 16))
            }
        }
    }
    
    var body: some View {
        HStack {
            HStack{
                btnBack
                Spacer()
            }
            .frame(width: 80)
            Spacer()
            Text("Create Outfit")
                .font(.custom("Montserrat-Bold", size: 14))
                .foregroundColor(.white)
            Spacer()
            HStack {
                Spacer()
                if viewModel.showSaveButton == true {
                    btnSave
                }
            }
            .frame(width: 80)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        .frame(height: 70)
        .background(Color(hex: "#6286C9").edgesIgnoringSafeArea(.all))
    }
    func didDismiss() {
    }
}
