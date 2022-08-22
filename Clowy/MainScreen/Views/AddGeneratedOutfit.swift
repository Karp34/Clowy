//
//  AddGenerated.swift
//  Clowy
//
//  Created by Егор Карпухин on 26.04.2022.
//

import SwiftUI

struct AddGeneratedOutfit: View {
    var isGenerated: Bool
    @State private var isShowingSheet = false
    var outfit: [Cloth]
    
    var body: some View {
        if isGenerated == true {
            Text("Outfit was automaticly generated")
                .font(.custom("Montserrat-Medium", size: 12))
                .foregroundColor(.gray)
            NavigationLink(destination: AddNewOutfitView(showSaveButton: true, newOutfit: outfit)) {
                Text("Add to My outfits")
                    .font(.custom("Montserrat-Medium", size: 12))
                    .foregroundColor(.blue)
            }
            .padding(.bottom)
        }
    }
}
        
