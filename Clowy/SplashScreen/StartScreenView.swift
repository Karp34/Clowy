//
//  StartScreenView.swift
//  Clowy
//
//  Created by Егор Карпухин on 16.09.2022.
//

import SwiftUI

struct StartScreenView: View {
    var textOffset: CGFloat
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                Color(hex: "#678CD4")
                Text("Clowy")
                    .font(.custom("Montserrat-Bold", size: 40))
                    .foregroundColor(.white)
                    .padding(.top, textOffset)
            }
            Text("Dress smarter. Look better.")
                .font(.custom("Montserrat-Medium", size: 14))
                .foregroundColor(.white)
                .padding(.bottom, 38)
        }
        .ignoresSafeArea(.all)
    }
}

