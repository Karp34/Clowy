//
//  WardrobeEmptyView.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import SwiftUI

struct WardrobeEmptyView: View {
    var textError: String?
    var errorCode: Int?
    var accentColor: Color

    @State private var isShowingSheet = false
    @State private var isPresented = false

    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .center, spacing: 16) {
                ZStack {
                    Circle()
                        .frame(width: 96, height: 96)
                        .foregroundColor(accentColor.opacity(0.2))
                    Image("Veshalka")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 41)
                        .foregroundColor(accentColor)
                }
                Text(textError ?? "No items in wardrobe")
                    .font(.custom("Montserrat-SemiBold", size: 20))
                    .foregroundColor(Color.primaryGrey)
                    .multilineTextAlignment(.center)
            }
            .frame(idealWidth: 279, idealHeight: 320)

            Spacer()

            Button {
                if errorCode == 402 {
                    isPresented.toggle()
                } else {
                    isShowingSheet.toggle()
                }
            } label: {
                ZStack {
                    Rectangle().foregroundColor(.clear)
                    Text("Add")
                        .font(.custom("Montserrat-Bold", size: 16))
                        .foregroundColor(.white)
                }
            }
            .padding(.bottom, 24)
            .buttonStyle(DefaultColorButtonStyle(color: accentColor, radius: 24))
//            .sheet(isPresented: $isShowingSheet) {
//                AddClothesView(isShowingSheet: $isShowingSheet)
//            }
            .fullScreenCover(isPresented: $isPresented) {
                CreateOutfitView()
            }
        }
    }
}
