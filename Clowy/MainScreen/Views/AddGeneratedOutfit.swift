//
//  AddGeneratedOutfit.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 11.12.2022.
//

import SwiftUI

struct AddGeneratedOutfit: View {
    var isGenerated: Bool
    @State private var isShowingSheet = false
    var outfit: [Cloth]
    
    var body: some View {
        if isGenerated {
            VStack {
                Text("Outfit was automaticly generated")
                    .font(.custom("Montserrat-Medium", size: 12))
                    .foregroundColor(.gray)
                NavigationLink(destination: AddNewOutfitView(outfit: outfit, newOutfit: outfit)) {
                    Text("Add to My outfits")
                        .font(.custom("Montserrat-Medium", size: 12))
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
