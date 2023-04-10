//
//  WardrobeTestClothCard.swift
//  Clowy
//
//  Created by Егор Карпухин on 29.06.2022.
//

import SwiftUI
import FirebaseStorage

class ClothesCardViewModel: ObservableObject {
    @Published var imageState: PlaceHolderState = .placeholder
    
    static var shared = ClothesCardViewModel()
}

struct ClothesCardView: View {
    @StateObject var clothViewModel = ClothesCardViewModel.shared
    @StateObject private var viewModel = MainScreenViewModel.shared
    @State var cloth: Cloth
    var selected: Bool? = false
    var deletable: Bool? = false
    
    @State private var showingAlert = false


    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
                .frame(width: 128, height: 164)
            if deletable == true {
                HStack {
                    Spacer()
                    VStack {
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
                            viewModel.deleteCloth(clothId: cloth.id, imageId: cloth.image)
                        }
                    )
                }
                .frame(width: 128, height: 164)
            }
            VStack(spacing: 8) {
                if cloth.image != "" {
                    ClothImage(imageName: cloth.image, isDeafult: cloth.isDefault, color: cloth.color, rawImage: cloth.rawImage)
                        .scaledToFit()
                        .frame(width: 96, height: 96)
                } else {
                    ZStack {
                        Circle()
                            .foregroundColor(Color(hex: "#678CD4"))
                            .opacity(0.2)
                            .frame(width: 56, height: 56)
                        Image("Veshalka")
                            .resizable()
                            .scaledToFit().frame(width: 24, height: 19)
                            .foregroundColor(Color(hex: "#678CD4"))
                    }
                    .frame(width: 96, height: 96)
                }
                
                Text(cloth.name )
                    .font(.custom("Montserrat-Regular", size: 12))
                    .multilineTextAlignment(.center)
                    .frame(width: 96, height: 32, alignment: .center)
                    .lineLimit(2)
                    .foregroundColor(Color(hex: "#606060"))
            }
            .frame(height: 128)
            
            if selected == true {
                HStack {
                    Spacer()
                    VStack {
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
                .frame(width: 128, height: 164)
            }
        }
        .shadow(color:Color(hex: "#646C75").opacity(0.1), radius: 10, y: 4)
    }
}
