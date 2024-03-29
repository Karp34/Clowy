////
////  WardrobeTestClothCard.swift
////  Clowy
////
////  Created by Егор Карпухин on 29.06.2022.
////
//
//import SwiftUI
//
//struct WardrobeTestClothCard: View {
//    @State var cloth: TestCloth
//    var selected: Bool? = false
//    var deletable: Bool? = false
//
//    @State private var showingAlert = false
//
//    func removeItem(items: FetchedResults<TestCloth>, id: UUID) {
//        for item in items {
//            if item.id == id {
//                PersistenceController.shared.delete(item)
//            }
//        }
//    }
//
//    @FetchRequest(
//        entity: TestCloth.entity(),
//        sortDescriptors: [NSSortDescriptor(keyPath: \TestCloth.name, ascending: true)]
//    ) var items: FetchedResults<TestCloth>
//
//    var body: some View {
//            ZStack {
//                if selected == true {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 16)
//                            .foregroundColor(.white)
//                        HStack {
//                            Spacer()
//                            VStack{
//                                ZStack {
//                                    Circle()
//                                        .foregroundColor(.green)
//                                        .frame(width: 24, height: 24)
//                                    Image("Ok")
//                                        .resizable()
//                                        .scaledToFit()
//                                        .foregroundColor(.white)
//                                        .frame(width: 14, height: 12)
//                                }
//                                .padding(8)
//                                Spacer()
//                            }
//                        }
//                    }
//                    .frame(width: 128, height: 164)
//                } else if deletable == true {
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 16)
//                            .foregroundColor(.white)
//                        HStack {
//                            Spacer()
//                            VStack{
//                                Image(systemName: "minus.circle")
//                                    .foregroundColor(.red)
//                                    .frame(width: 24, height: 24)
//                                    .padding(8)
//                                Spacer()
//                            }
//                        }
//                        .onTapGesture {
//                            showingAlert = true
//                        }
//                        .alert(isPresented: $showingAlert) {
//                            Alert(
//                                title: Text("Delete cloth"),
//                                message: Text("Do you want to delete this cloth?"),
//                                primaryButton:  .default(Text("No")) {
//                                    print("No")
//                                },
//                                secondaryButton:  .default(Text("Yes")){
//                                    print("Yes")
//                                    removeItem(items: items, id: cloth.id!)
//                                }
//                            )
//                        }
//                    }
//                    .frame(width: 128, height: 164)
//                } else {
//                    RoundedRectangle(cornerRadius: 16)
//                        .foregroundColor(.white)
//                        .frame(width: 128, height: 164)
//                }
//                VStack(spacing: 8) {
//                    if cloth.image != nil {
//                        ClothImage(imageName: cloth.image, isDeafult: cloth.isDefault, color: cloth.color ?? "#FFFFFF")
//                            .scaledToFit()
//                            .frame(width: 96, height: 96)
//                    } else {
//                        Image(systemName: "t-shirt")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 96, height: 96)
//                    }
//
//                    Text(cloth.name ?? "Cloth")
//                        .font(.custom("Montserrat-Regular", size: 12))
//                        .multilineTextAlignment(.center)
//                        .frame(width: 96, height: 32, alignment: .center)
//                        .lineLimit(2)
//                        .foregroundColor(Color(hex: "#606060"))
//                }
//                .frame(height: 128)
//        }
//            .shadow(color:Color(hex: "#646C75").opacity(0.1), radius: 10, y: 4)
//    }
//}
