////
////  CoreDataView.swift
////  Clowy
////
////  Created by Егор Карпухин on 25.05.2022.
////
//
//import SwiftUI
//import AVFAudio
//
//struct CoreDataView: View {
//    
//    @Environment(\.managedObjectContext) var managedObjectContext
//    
//    @FetchRequest(
//        entity: TestCloth.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \TestCloth.name, ascending: true)]
//    ) var items: FetchedResults<TestCloth>
//    
//    @FetchRequest(
//        entity: TestWardrobe.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \TestWardrobe.name, ascending: true)]
//    ) var categories: FetchedResults<TestWardrobe>
//    
//    @State private var isActionSheetPresented = false
//    @State private var isAlertPresented = false
//    
//    func removeItem(at offsets: IndexSet) {
//        for index in offsets {
//            let item = items[index]
//            PersistenceController.shared.delete(item)
//        }
//    }
//    
//    
//    
//    @State var clothes: [Wardrobe] = []
//    private func getClothes() {
//        let resultClothes = GetClothes.getClothes()
//        clothes = resultClothes
//    }
//    
//    
//    @State var newClothesIdString: String = ""
//    var newClothesId : Int16 {
//           get {
//            return Int16(newClothesIdString) ?? 0
//           }
//       }
//    @State var newClothesName: String = ""
//    @State var newClothesClothesType: String = ""
//    @State var newClothesTemp: String = ""
//    @State var newClothesImage: String = ""
//    
//    @State var newWardrobeName: String = ""
//    @State var newWardrobeIdString: String = ""
//    var newWardrobeId : Int16 {
//           get {
//            return Int16(newWardrobeIdString) ?? 0
//           }
//       }
//    
////    func updateWardrobe(wardrobe: TestWardrobe, cloth: TestCloth) {
////        var oldWardrobe = wardrobe.items
////        var newWardrobe: [TestCloth]
////        managedObjectContext.performAndWait {
////            if oldWardrobe != nil {
////                for item in (oldWardrobe!) {
////                    newWardrobe.append(clothes)
////                }
////                newWardrobe.append(cloth)
////                try? managedObjectContext.save()
////            }
////        }
////    }
//
//    
//    var body: some View {
//        
//        VStack (spacing: 8) {
//            VStack {
//                TextField("Id", text: $newWardrobeIdString)
//                HStack {
//                    ForEach(0..<21) { id in
//                        ForEach(clothes) { cloth in
//                            var color = Color.gray
//                            if id == cloth.id.rawValue {
//                                Text(cloth.clothesTypeName.rawValue)
//                                    .onTapGesture {
//                                        newWardrobeName = cloth.clothesTypeName.rawValue
//                                        color = .blue
//                                    }
//                                    .background(color)
//                            }
//                        }
//                    }
//                }
//                if newWardrobeId != 0 && newWardrobeName != "" {
//                    Button {
//                        let category = TestWardrobe(context: managedObjectContext)
//                        category.name = newWardrobeName
//                        category.id = newWardrobeId
//                        PersistenceController.shared.save()
//                    } label: {
//                        Text("Save Wardrobe")
//                    }
//                }
//            }
//            .padding(.vertical, 15)
//            .background(Color.green.opacity(0.15))
//            .onAppear() {
//                getClothes()
//            }
//            
//            
//            VStack {
//                TextField("Id", text: $newClothesIdString)
//                TextField("Name", text: $newClothesName)
//                HStack {
//                    ForEach(0..<21) { id in
//                        ForEach(clothes) { cloth in
//                            if id == cloth.id.rawValue {
//                                Text(cloth.clothesTypeName.rawValue)
//                                    .onTapGesture {
//                                        newClothesClothesType = cloth.clothesTypeName.rawValue
//                                    }
//                            }
//                        }
//                    }
//                }
//                TextField("Temp", text: $newClothesTemp)
//                TextField("Image", text: $newClothesImage)
//                
//                if newClothesId != 0 && newClothesName != "" && newClothesClothesType != "" && newClothesTemp != "" {
//                    ForEach (categories) { category in
//                        Button {
//                            let clothes = TestCloth(context: managedObjectContext)
////                            clothes.id = newClothesId
//                            clothes.clothesType = newClothesClothesType
//                            clothes.name = newClothesName
////                            clothes.temp = newClothesTemp
//                            clothes.toTestWardrobe = category
////                            clothes.image = newClothesImage
//                            PersistenceController.shared.save()
//                        } label: {
//                            Text(category.name ?? "Unknown")
//                        }
//                    }
//                }
//            }
//            .padding(.vertical, 15)
//            .background(Color.blue.opacity(0.15))
//            .onAppear() {
//                getClothes()
//            }
//        }
//        
//        VStack {
//            Text("Итого")
//            Text(String(newClothesId))
//            Text(newClothesName)
//            Text(newClothesClothesType)
//            Text(newClothesTemp)
//        }
//        
//        VStack {
//            Text("Items")
//            ForEach(items) { item in
//                Text("\(item.name ?? "Unknown") - \(item.toTestWardrobe?.name ?? "Unknown")")
//            }
//        }
//        .padding(.vertical)
//        
//        VStack {
//            Text("Categories")
//            ForEach(categories) { category in
//                Text("\(category.name ?? "Unknown")")
//            }
//        }
//        .padding(.vertical)
//    }
//}
