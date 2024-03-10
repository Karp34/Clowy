//
//  SunSplachScreen.swift
//  Clowy
//
//  Created by Egor Karpukhin on 08/12/2023.
//

import SwiftUI

struct SunSplachScreen: View {
    @State private var moveAlongPass = -15
    var body: some View {
        ZStack {
            Image("SplashSun")
                .resizable()
                .rotationEffect(.degrees(Double(125)))
                .offset(x: -900)
                .frame(width: 900, height: 900)
                .rotationEffect(.degrees(Double(moveAlongPass)))
                .offset(x:600, y:750)
                .blur(radius: 75)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 4).repeatForever(autoreverses: false)) {
                        moveAlongPass = 115
                    }
                }
            Text("clowy")
                .font(.custom("Pacifico-Regular", size: 73))
                .foregroundColor(.white)
        }
        .background(Color(hex: "#678CD4"))
        .ignoresSafeArea(.all)
    }
}
//
//#Preview {
//    SunSplachScreen()
//}
