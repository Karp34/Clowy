////
////  AddNewOutfitView.swift
////  Clowy
////
////  Created by Егор Карпухин on 27.04.2022.
////
//
//import SwiftUI
//
//class AddNewOutfitViewModel: ObservableObject {
//    @Published var isSavingOutfit = false
//    @Published var name: String = ""
//}
//
//struct AddNewOutfitView: View, WardrobeclothesCardCollectionDelegate{
//    @ObservedObject var viewModel = AddNewOutfitViewModel()
////    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    
//    @State var outfit: [Cloth] = []
//    @State var isEditing: Bool = true
//    @State var showSaveButton: Bool = false
//    
//    var newOutfit: [Cloth]?
//    
//    @State var defaultOutfit: [Cloth] = [
//    Cloth(id: 1100, name: "", clothesType: .tshirts, image: "DefaultUpperWear"),
//    Cloth(id: 1101, name: "", clothesType: .pants, image: "DefaultPants"),
//    Cloth(id: 1102, name: "", clothesType: .sneakers, image: "DefaultSneaker")
//    ]
//    
//    
//    @State var clothes: [Wardrobe] = []
//    private func getClothes() {
//        let resultClothes = GetClothes.getClothes()
//        clothes = resultClothes
//    }
//
//    func appendToOutfit(cloth: Cloth) {
//        let defaulClothesType = [
//            Cloth(id: 1100, name: "", clothesType: .tshirts, image: "DefaultUpperWear"),
//            Cloth(id: 1101, name: "", clothesType: .pants, image: "DefaultPants"),
//            Cloth(id: 1102, name: "", clothesType: .sneakers, image: "DefaultSneaker")
//        ]
//        
//        let upperClothesTypes = [ClothesType.hoodies, ClothesType.jackets, ClothesType.thermals, ClothesType.tshirts]
//        
//        
//        if !defaultOutfit.contains(cloth) {
//            if let index = defaultOutfit.firstIndex(where: {$0.clothesType == cloth.clothesType }) {
//                defaultOutfit.remove(at: (index))
//            }
//            else if upperClothesTypes.contains(cloth.clothesType) {
//                if let index = defaultOutfit.firstIndex(where: {$0.id == 1100}) {
//                    defaultOutfit.remove(at: (index))
//                }
//            }
//            defaultOutfit.append(cloth)
//        } else {
//            let index = defaultOutfit.firstIndex(where: {$0.clothesType == cloth.clothesType })
//            defaultOutfit.remove(at: (index)!)
//            
//            var outfitTypes = [ClothesType]()
//            for id in defaultOutfit {
//                outfitTypes.append(id.clothesType)
//            }
//            
//            for cloth in defaulClothesType {
//                if !defaultOutfit.contains(cloth) && !outfitTypes.contains(cloth.clothesType){
//                    var isUpperType = false
//                    for type in outfitTypes {
//                        if upperClothesTypes.contains(type) {
//                            isUpperType = true
//                        }
//                    }
//                    if !isUpperType {
//                        defaultOutfit.append(cloth)
//                        break
//                    }
//                    
//                    if cloth.clothesType == ClothesType.pants || cloth.clothesType == ClothesType.sneakers {
//                        defaultOutfit.append(cloth)
//                        break
//                    }
//                    
//                }
//            }
//        }
//        
//        var contains = false
//        for item in defaulClothesType {
//            if defaultOutfit.contains(item) {
//                contains = true
//            }
//        }
//        showSaveButton = !contains
//    }
//    
//    var body: some View {
//        ZStack {
//            VStack (alignment: .leading, spacing: 24){
//                VStack (alignment: .leading, spacing: 0){
//                    NewOutfitNavBar(viewModel: viewModel, showSaveButton: showSaveButton)
//                    OutfitView(outfit: defaultOutfit, isEditing: isEditing, delegate: self)
//                }
//                    .background(Color(hex: "#6286C9").frame(height: 1200).edgesIgnoringSafeArea(.all))
//                CustomSheetView(radius: 32, color: "#F7F8FA", clearCornerColor: "#6286C9") {
//                    ScrollView  (.vertical, showsIndicators: false){
//                        VStack {
//                            Spacer(minLength: 24)
//                            ForEach(clothes) { clothesType in
//                                OutfitWardrobeView(delegate: self, clothesTypeName: clothesType.clothesTypeName.rawValue, clothList: clothesType.items, defaultOutfit: defaultOutfit)
//                            }
//                        }
//                    }
//                }
//            }
//            .navigationBarHidden(true)
//            .onAppear() {
//                getClothes()
//                defaultOutfit = newOutfit ?? defaultOutfit
//            }
//            .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
//            
//            if viewModel.isSavingOutfit {
//                VStack(spacing: 0) {
//                    Rectangle()
//                        .foregroundColor(Color(hex: "#CCCCCCCC"))
//                        .onTapGesture {
//                            withAnimation {
//                                viewModel.isSavingOutfit = false
//                            }
//                        }
//                    CustomSheetView(radius: 32, color: "#FFFFFF", clearCornerColor: "#CCCCCCCC") {
//                        VStack(alignment: .leading, spacing: 32) {
////                            InputNameView(newClothesName: viewModel.name, title: "Create outfit", hint: "Input outfit's name")
////                            InputNameView(title: "Create outfit", hint: "Input outfit's name")
//                            ZStack {
//                                RoundedRectangle(cornerRadius: 24)
//                                    .frame(height: 56)
//                                    .foregroundColor(Color(hex: "#CBCED2"))
//                                Text("SAVE")
//                                    .font(.custom("Montserrat-SemiBold", size: 16))
//                                    .foregroundColor(.white)
//                            }
//                            .padding(.bottom, 40)
//                        }
//                        .padding(.horizontal, 24)
//                    }
//                    .frame(height: 234)
//                }
//                .edgesIgnoringSafeArea(.all)
//            }
//        }
//    }
//}
//
//
//struct OutfitWardrobeView: View {
//    
//    var delegate: WardrobeclothesCardCollectionDelegate
//    var clothesTypeName: String
//    var clothList: [Cloth]
//    var defaultOutfit: [Cloth]
//    
//    
//    
//    var body: some View {
//        if !clothList.isEmpty {
//            WardrobeClothesCardCollection(name: clothesTypeName, clothes: clothList, selectedClothes: defaultOutfit, delegate: delegate)
//        } else {
//            NoClothesCollection(name: clothesTypeName)
//        }
//    }
//}
//
//struct NewOutfitNavBar: View {
//    @ObservedObject var viewModel: AddNewOutfitViewModel
//    
//    var showSaveButton: Bool
//    
//    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
//    @State private var isShowingSheet = false
//    
//    var btnBack : some View {
//        Button (action: {
//            self.presentationMode.wrappedValue.dismiss()}) {
//                Image("back_button")
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 12.0, height: 12.0).contentShape(Rectangle())
//                    .foregroundColor(.white)
//            }
//    }
//    
//    var btnSave : some View {
//        Button(action: {
//            withAnimation {
//                viewModel.isSavingOutfit = true
//            }
//        }) {
//            ZStack{
//                RoundedRectangle(cornerRadius: 8)
//                    .foregroundColor(Color(hex: "#7CA8FF"))
//                    .frame(width: 64, height: 32)
//                Text("SAVE")
//                    .foregroundColor(.white)
//                    .font(.custom("Montserrat-Bold", size: 16))
//            }
//        }
//    }
//    
//    var body: some View {
//        HStack {
//            HStack{
//                btnBack
//                Spacer()
//            }
//            .frame(width: 80)
//            Spacer()
//            Text("Create Outfit")
//                .font(.custom("Montserrat-Bold", size: 14))
//                .foregroundColor(.white)
//            Spacer()
//            HStack {
//                Spacer()
//                if showSaveButton == true {
//                    btnSave
//                }
//            }
//            .frame(width: 80)
//        }
//        .padding(.horizontal)
//        .padding(.bottom, 20)
//        .frame(height: 70)
//        .background(Color(hex: "#6286C9").edgesIgnoringSafeArea(.all))
//    }
//    func didDismiss() {
//    }
//}
