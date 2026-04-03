//
//  CreateOutfitNavBar.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI

struct CreateOutfitNavBar: View {
    var showSaveButton: Bool
    var onBack: () -> Void
    var onSave: () -> Void

    var body: some View {
        HStack {
            HStack {
                Button(action: onBack) {
                    Image("back_button")
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12, height: 12)
                        .contentShape(Rectangle())
                        .foregroundColor(.white)
                }
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
                if showSaveButton {
                    Button(action: onSave) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundColor(Color.secondaryBlueBrand)
                                .frame(width: 64, height: 32)
                            Text("SAVE")
                                .foregroundColor(.white)
                                .font(.custom("Montserrat-Bold", size: 16))
                        }
                    }
                }
            }
            .frame(width: 80)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
        .frame(height: 70)
        .background(Color.primaryBlueBrand.edgesIgnoringSafeArea(.all))
    }
}
