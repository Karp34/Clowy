//
//  WardrobeTestClothCard.swift
//  Clowy
//
//  Created by Егор Карпухин on 29.06.2022.
//

import SwiftUI

struct WardrobeTestClothCard: View {
    @State var cloth: TestCloth
    var selected: Bool? = false
    var deletable: Bool? = false
    
    @State private var showingAlert = false
    
    func removeItem(items: FetchedResults<TestCloth>, id: UUID) {
        for item in items {
            if item.id == id {
                PersistenceController.shared.delete(item)
            }
        }
    }
    
    @FetchRequest(
        entity: TestCloth.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \TestCloth.name, ascending: true)]
    ) var items: FetchedResults<TestCloth>

    var body: some View {
            ZStack {
                if selected == true {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.white)
//                            .frame(width: 128, height: 164)
                        HStack {
                            Spacer()
                            VStack{
                                ZStack {
                                    Circle()
                                        .foregroundColor(.green)
                                        .frame(width: 24, height: 24)
                                    Image("Ok")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 14, height: 12)
                                }
                                .padding(8)
                                Spacer()
                            }
                        }
                    }
                    .frame(width: 128, height: 164)
                } else if deletable == true {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .foregroundColor(.white)
                        HStack {
                            Spacer()
                            VStack{
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                                    .frame(width: 24, height: 24)
                                    .padding(8)
                                Spacer()
                            }
                        }
                        .onTapGesture {
                            showingAlert = true
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
                                    removeItem(items: items, id: cloth.id!)
                                }
                            )
                        }
                    }
                    .frame(width: 128, height: 164)
                } else {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundColor(.white)
                        .frame(width: 128, height: 164)
                }
                VStack {
                    if cloth.image != nil {
                        Image(uiImage: UIImage(data: cloth.image!)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 100)
                    } else {
                        Image(systemName: "t-shirt")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 100)
                    }
                    
                    Text(cloth.name ?? "Cloth")
                        .font(.custom("Montserrat-Regular", size: 14))
                        .multilineTextAlignment(.center)
                        .frame(width: 100)
                        .scaledToFill()
                        .padding(.vertical, 2)
                        .foregroundColor(Color(hex: "#606060"))
                }
                .padding()
        }
            .shadow(color:Color(hex: "#646C75").opacity(0.1), radius: 10, y: 4)
    }
}
