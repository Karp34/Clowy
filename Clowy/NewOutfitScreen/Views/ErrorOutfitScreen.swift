//
//  ErrorOutfitScreen.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 08.11.2022.
//

import SwiftUI

struct ErrorOutfitScreen: View {
    var body: some View {
        VStack {
            Spacer()
            WarningView(image: Image(systemName: "exclamationmark.circle.fill"), title: "Failed to load clothes")
            Spacer()
            Button(action: {
                print("AA")
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 56)
                    Text("Try again")
                        .font(.custom("Montserrat-Bold", size: 16))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(DefaultColorButtonStyle(color: "#678CD4", radius: 24))
            .padding(.horizontal, 24)
        }
    }
}
