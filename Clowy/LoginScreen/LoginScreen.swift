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
                    VStack(alignment: .center, spacing: 16) {
                        VStack(alignment: .center, spacing: 8) {
                            Text("Welcome")
                                .font(.custom("Montserrat-Bold", size: 24))
                                .foregroundColor(Color(hex: "#646C75"))
                            Text("Please sign in with your account")
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color(hex: "#646C75"))
                        }
                        .padding(.top, 24)
                        .padding(.bottom, 16)

                        VStack(spacing: 16) {
                            TextField("Enter your email", text: $viewModel.userEmail)
                                .padding(.horizontal, 16)
                                .textFieldStyle(CustomFieldStyle3(size: 16))
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .strokeBorder(Color(hex: "#DADADA"))
                                        .foregroundColor(.white)
                                        .frame(height: 56)
    //                                    .border(Color(hex: "#DADADA"))
                                        
                                )
                                
                                .padding(.bottom, 32)
                            
                            
                            TextField("Password in future Name", text: $viewModel.userPassword)
                                .padding(.horizontal, 16)
                                .textFieldStyle(CustomFieldStyle3(size: 16))
                                .background(
                                    RoundedRectangle(cornerRadius: 24)
                                        .strokeBorder(viewModel.userPassword.count > 0 ? Color(hex: "#678CD4") : Color(hex: "#DADADA"))
                                        .foregroundColor(.white)
                                        .frame(height: 56)
                                        
                                )
                                
                                .padding(.bottom, 16)

                            Button {
                                viewModel.login()
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Login")
                                        .font(.custom("Montserrat-Bold", size: 16))
                                        .foregroundColor(.white)
                                    Spacer()
                                }
                            }
                            .frame(height: 24)
                            .buttonStyle(DefaultColorButtonStyle(color: "#678CD4", radius: 24))
                            .padding(.vertical, 16)
                            
                        }
                        .shadow(color:Color(hex: "#646C75").opacity(0.1), radius: 30, y: 4)
                        
                        Spacer()
                            .frame(height: 60)

                        
                        Text("Login with social networks")
                            .font(.custom("Montserrat-Regular", size: 12))
                            .foregroundColor(Color(hex: "#99A2AD"))
                        
                        HStack(spacing: 40) {
                            Button {
                                skip()
                            } label: {
                                Image(systemName: "applelogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 17, height: 17)
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(DefaultCircleColorButtonStyle(color: "#678CD4", size: 32))
                            
                            Button {
                                skip()
                            } label: {
                                Image(systemName: "applelogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 17, height: 17)
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(DefaultCircleColorButtonStyle(color: "#678CD4", size: 32))
                            
                            Button {
                                skip()
                            } label: {
                                Image(systemName: "applelogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 17, height: 17)
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(DefaultCircleColorButtonStyle(color: "#678CD4", size: 32))
                            
                            Button {
                                skip()
                            } label: {
                                Image(systemName: "applelogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 17, height: 17)
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(DefaultCircleColorButtonStyle(color: "#678CD4", size: 32))
                        }
                        .frame(height: 32)
                        .padding(.bottom, 56)
                    }
                    .padding(.horizontal, 24)
    //                .padding(.bottom, 200)
                    .background(Color(hex: "#F7F8FA").padding(.bottom, -200))
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
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
