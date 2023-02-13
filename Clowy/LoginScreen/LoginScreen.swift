//
//  LoginScreen.swift
//  Clowy
//
//  Created by Егор Карпухин on 09.02.2023.
//

import SwiftUI
import Firebase

struct LoginScreen: View {
    @StateObject private var viewModel = MainScreenViewModel.shared
    @State var offset: CGFloat = 500
    @State var startAnimation = false
    @State var textOffset: CGFloat = 300
    
    func skip() {}
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack {
                    Color(hex: "#678CD4")
                    Text("Clowy")
                        .font(.custom("Montserrat-Bold", size: 40))
                        .foregroundColor(.white)
                        .padding(.top, textOffset)
                }
                .onAppear {
                    textOffset = geometry.size.height/2
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) {
                        withAnimation(.easeInOut) {
                            textOffset = 0
                        }
                    }
                }

                CustomSheetView(radius: 16, color: "#F7F8FA", clearCornerColor: "#678CD4", topLeftCorner: true, topRightCorner: true) {
                    if viewModel.showSecondPage {
                        LoginSecondPage()
                    } else {
                        LoginFirstPage()
                    }
                }
                .offset(y: offset)
            }
            .background(Color(hex: "#678CD4"))
            
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) {
                    withAnimation(.interactiveSpring(response: 1, dampingFraction: 0.5, blendDuration: 0.3)) {
                        offset = 0
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
//        .ignoresSafeArea(.all)
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
