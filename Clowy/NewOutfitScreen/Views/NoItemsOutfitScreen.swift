//
//  NoItemsOutfitScreen.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 08.11.2022.
//

import SwiftUI

struct NoItemsOutfitScreen: View {
    var body: some View {
        VStack {
            Spacer()
            WarningView(image: Image("Liked"), title: "No clothing sets", subtitle: "Here you can create a set of clothes for any purpose and weather", color: "#678CD4")
            Spacer()
            
            NavigationLink(destination: AddNewOutfitView()) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 56)
                    Text("Create outfits")
                        .font(.custom("Montserrat-Bold", size: 16))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(DefaultColorButtonStyle(color: "#678CD4", radius: 24))
            .padding(.horizontal, 24)
        }
    }
}
