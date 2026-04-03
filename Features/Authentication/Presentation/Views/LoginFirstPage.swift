//
//  LoginFirstPage.swift
//  Clowy
//
//  Created by Егор Карпухин on 12.02.2023.
//

import SwiftUI

struct LoginFirstPage: View {
    @EnvironmentObject var viewModel: LoginViewModel

    @State var emailIsValid = false
    @State var checkCount = 0
    @State var showError = false

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            VStack(alignment: .center, spacing: 8) {
                Text("Welcome")
                    .font(.custom("Montserrat-Bold", size: 24))
                    .foregroundColor(Color.primaryGrey)
                Text("Please sign in with your account")
                    .font(.custom("Montserrat-Regular", size: 12))
                    .foregroundColor(Color.primaryGrey)
            }
            .padding(.top, 24)

            VStack(spacing: 16) {
                // Email field
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        if !emailIsValid && viewModel.userEmail.count > 0 && checkCount > 0 {
                            Text("Incorrect email")
                                .font(.custom("Montserrat-Regular", size: 12))
                                .foregroundColor(Color.errorRed)
                        }
                        TextField("Enter your email", text: $viewModel.userEmail, onEditingChanged: { _ in
                            emailIsValid = viewModel.isValidEmail(viewModel.userEmail)
                        }, onCommit: {
                            emailIsValid = viewModel.isValidEmail(viewModel.userEmail)
                            checkCount += 1
                        })
                        .textFieldStyle(CustomFieldStyle3(size: 16))
                    }

                    if checkCount > 0 {
                        ZStack {
                            Circle()
                                .foregroundColor(emailIsValid ? Color.successGreen : Color.errorRed)
                                .frame(width: 18, height: 18)
                            Image(emailIsValid ? "Ok" : "systemName: multiply")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.white)
                                .frame(width: 10, height: 10)
                        }
                        .padding(3)
                    }
                }
                .frame(height: 56)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(
                            emailIsValid ? Color.separatorGrey :
                            viewModel.userEmail.count > 0 && checkCount > 0 ? Color.errorRed : Color.separatorGrey
                        )
                        .foregroundColor(.white)
                        .frame(height: 56)
                )
                .padding(.bottom, 16)

                // Password field
                TextField("Password", text: $viewModel.userPassword, onEditingChanged: { _ in
                    emailIsValid = viewModel.isValidEmail(viewModel.userEmail)
                    checkCount += 1
                })
                .padding(.horizontal, 16)
                .textFieldStyle(CustomFieldStyle3(size: 16))
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .strokeBorder(viewModel.userPassword.count > 2 ? Color.primaryBlueBrand : Color.separatorGrey)
                        .foregroundColor(.white)
                        .frame(height: 56)
                )
                .padding(.bottom, 16)

                // Login button
                Button {
                    Task {
                        withAnimation { viewModel.showSecondPage = true }
                        await viewModel.login()
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
                .buttonStyle(DefaultColorButtonStyle(color: Color.primaryBlueBrand, radius: 24))
                .disabled(!viewModel.isLoginEnabled)
                .padding(.vertical, 16)
                .alert(isPresented: Binding(
                    get: { viewModel.loginError != nil },
                    set: { if !$0 { viewModel.loginError = nil } }
                )) {
                    Alert(
                        title: Text("Login Error"),
                        message: Text(viewModel.loginError ?? ""),
                        dismissButton: .cancel()
                    )
                }
            }
            .shadow(color: Color.primaryGrey.opacity(0.1), radius: 30, y: 4)

            Spacer().frame(height: 84)

            Text("Login with social networks")
                .font(.custom("Montserrat-Regular", size: 12))
                .foregroundColor(Color.primaryGrey)

            HStack(spacing: 40) {
                ForEach(0..<4, id: \.self) { _ in
                    Button {
                        Task { await viewModel.register() }
                    } label: {
                        Image(systemName: "applelogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 17, height: 17)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(DefaultCircleColorButtonStyle(color: Color.primaryBlueBrand, size: 32))
                }
            }
            .frame(height: 32)

            Spacer().frame(height: 84)
        }
        .padding(.horizontal, 24)
        .frame(height: 565)
        .background(Color.primaryBackground.padding(.bottom, -200))
    }
}
