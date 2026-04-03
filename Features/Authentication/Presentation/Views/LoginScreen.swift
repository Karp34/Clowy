//
//  LoginScreen.swift
//  Clowy
//
//  Created by Егор Карпухин on 09.02.2023.
//
import SwiftUI

struct LoginScreen: View {
    var onLoginSuccess: () -> Void
    @StateObject private var viewModel = LoginViewModel()
    @State var offset: CGFloat = 500
    @State var textOffset: CGFloat = 10

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack {
                    Color.primaryBlueBrand
                    Text("clowy")
                        .font(.custom("Pacifico-Regular", size: 73))
                        .foregroundColor(.white)
                        .padding(.top, textOffset)
                }
                .onAppear {
                    textOffset = geometry.size.height / 2 - 20
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut) { textOffset = 0 }
                    }
                }

                CustomSheetView(
                    radius: 16,
                    color: Color.primaryBackground,
                    clearCornerColor: Color.primaryBlueBrand,
                    topLeftCorner: true,
                    topRightCorner: true
                ) {
                    if viewModel.showSecondPage {
                        LoginSecondPage()
                    } else {
                        LoginFirstPage()
                    }
                }
                .offset(y: offset)
            }
            .background(Color.primaryBlueBrand)
            .ignoresSafeArea()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.interactiveSpring(response: 1, dampingFraction: 0.7, blendDuration: 0.1)) {
                        offset = 0
                    }
                }
            }
        }
        .environmentObject(viewModel)
        .ignoresSafeArea(.keyboard)
    }
}
