//
//  SunSplachScreen.swift
//  Clowy
//
//  Created by Egor Karpukhin on 08/12/2023.
//

import SwiftUI

struct SunSplachScreen: View {
    @State private var moveAlongPass = -90
    var body: some View {
        ZStack {
            ZStack {
                Color(hex: "#678CD4")
                Text("Clowy")
                    .font(.custom("Montserrat-Bold", size: 40))
                    .foregroundColor(.white)
            }
            .background(Color.green)
            Image(systemName: "sun.max.fill")
                .resizable()
                .frame(width: 600, height: 600)
                .foregroundColor(.yellow)
                .offset(x: -400)
                .rotationEffect(.degrees(Double(moveAlongPass)))
                .offset(x:300, y:300)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 5)) {
                        moveAlongPass = 130
                    }
                }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    SunSplachScreen()
}
