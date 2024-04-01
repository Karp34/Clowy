//
//  LoginFirstPage.swift
//  Clowy
//
//  Created by Егор Карпухин on 12.02.2023.
//

import SwiftUI

struct LoginFirstPage: View {
    @StateObject private var viewModel = MainScreenViewModel.shared
    @State var emailIsValid = false
    @State var checkCount = 0
    @State var isEditing = false
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var body: some View {
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

            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        if !emailIsValid && viewModel.userEmail.count > 0 && checkCount > 0 {
                            Text("Incorrect email")
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color(hex: "#D85858"))
                        }
                        TextField("Enter your email", text: $viewModel.userEmail, onEditingChanged: { isEditing in
                            emailIsValid = isValidEmail(viewModel.userEmail)
                        }, onCommit: {
                            emailIsValid = isValidEmail(viewModel.userEmail)
                            checkCount += 1
                        })
                            .textFieldStyle(CustomFieldStyle3(size: 16))
                    }
                        
                    
                    
                    if checkCount > 0 {
                        ZStack {
                            Circle()
                                .foregroundColor(emailIsValid ? Color(hex: "#79D858") : Color(hex: "D85858"))
                                .frame(width: 18, height: 18)
                            if emailIsValid {
                                Image("Ok")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 10, height: 10)
                            } else {
                                Image(systemName: "multiply")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.white)
                                    .frame(width: 10, height: 10)
                            }
                        }
                        .padding(3)
                    }
                }
                .frame(height: 56)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(emailIsValid ? Color(hex: "#DADADA") : viewModel.userEmail.count > 0 && checkCount > 0 ? Color(hex: "#D85858") : Color(hex: "#DADADA"))
                        .foregroundColor(.white)
                        .frame(height: 56)
                )
                .padding(.bottom, 16)
                
                
                TextField("Password in future Name", text: $viewModel.userPassword, onEditingChanged: { isEditing in
                    emailIsValid = isValidEmail(viewModel.userEmail)
                    checkCount += 1
                })
                    .padding(.horizontal, 16)
                    .textFieldStyle(CustomFieldStyle3(size: 16))
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(viewModel.userPassword.count > 2 ? Color(hex: "#678CD4") : Color(hex: "#DADADA"))
                            .foregroundColor(.white)
                            .frame(height: 56)
                            
                    )
                    
                    .padding(.bottom, 16)

                Button {
                    withAnimation {
                        viewModel.showSecondPage = true
                        viewModel.login()
                    }
                    
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
                .disabled(emailIsValid && viewModel.userPassword.count > 2 ? false : true )
                .padding(.vertical, 16)
                
            }
            .shadow(color:Color(hex: "#646C75").opacity(0.1), radius: 30, y: 4)
            
            Spacer()
                .frame(height: 84)

            
            Text("Login with social networks")
                .font(.custom("Montserrat-Regular", size: 12))
                .foregroundColor(Color(hex: "#99A2AD"))
            
            HStack(spacing: 40) {
                Button {
                    viewModel.register()
                } label: {
                    Image(systemName: "applelogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 17, height: 17)
                        .foregroundColor(.white)
                }
                .buttonStyle(DefaultCircleColorButtonStyle(color: "#678CD4", size: 32))
                
                Button {
                    
                } label: {
                    Image(systemName: "applelogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 17, height: 17)
                        .foregroundColor(.white)
                }
                .buttonStyle(DefaultCircleColorButtonStyle(color: "#678CD4", size: 32))
                
                Button {
                    
                } label: {
                    Image(systemName: "applelogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 17, height: 17)
                        .foregroundColor(.white)
                }
                .buttonStyle(DefaultCircleColorButtonStyle(color: "#678CD4", size: 32))
                
                Button {
                    
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
//                        .padding(.bottom, 86)
            Spacer()
                .frame(height: 84)
        }
        .padding(.horizontal, 24)
        .frame(height: 565)
        .background(Color(hex: "#F7F8FA").padding(.bottom, -200))
    }
}
