//
//  LoginScreen.swift
//  Clowy
//
//  Created by Егор Карпухин on 07.02.2023.
//

import SwiftUI
import Firebase

struct LoginScreen: View {
    @StateObject private var viewModel = MainScreenViewModel.shared
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var body: some View {
        ZStack {
            Color.black

            RoundedRectangle(cornerRadius: 30, style: .continuous)
//                .foregroundStyle(.linearGradient( colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 300)
                .rotationEffect(.degrees(135))
                .offset(y: -350)

            VStack(spacing: 20) {
                Text("Welcome")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .offset(x: -100, y: -100)

                TextField("Email", text: $viewModel.userEmail)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: viewModel.userEmail.isEmpty) {
                        Text("Email")
                            .foregroundColor(.white)
                            .bold()
                    }

                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)

                TextField("Password", text: $viewModel.userPassword)
                    .foregroundColor(.white)
                    .textFieldStyle(.plain)
                    .placeholder(when: viewModel.userPassword.isEmpty) {
                        Text("Password")
                            .foregroundColor(.white)
                            .bold()
                    }

                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)

                Button {
                    viewModel.register()
                } label: {
                    Text("Sign Up")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                }
                .padding(.top)
                .offset(y: 100)

                Button {
                    viewModel.login()
                } label: {
                    Text("Already have an account? Login")
                        .bold()
                        .foregroundColor(.white)
                }
                .padding(.top)
                .offset(y: 110)


            }
            .frame(width: 350)
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        viewModel.userIsLoggedIn.toggle()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}

struct LoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreen()
    }
}
