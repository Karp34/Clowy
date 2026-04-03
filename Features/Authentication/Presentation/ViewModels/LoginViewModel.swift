//
//  LoginViewModel.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import SwiftUI
import Firebase

@MainActor
final class LoginViewModel: ObservableObject {

    // MARK: - Published

    @Published var userEmail: String = ""
    @Published var userPassword: String = ""
    @Published var showSecondPage: Bool = false
    @Published var userIsLoggedIn: Bool = false
    @Published var loginError: String? = nil

    // MARK: - Computed

    var isLoginEnabled: Bool {
        isValidEmail(userEmail) && userPassword.count > 2
    }

    // MARK: - Auth

    func login() async {
        do {
            let result = try await Auth.auth().signIn(withEmail: userEmail, password: userPassword)
            let userId = result.user.uid
            DIContainer.shared.setup(userId: userId)
            userIsLoggedIn = true
        } catch {
            loginError = error.localizedDescription
            AppLogger.error(error, category: .auth)
        }
    }

    func register() async {
        do {
            try await Auth.auth().createUser(withEmail: userEmail, password: userPassword)
        } catch {
            loginError = error.localizedDescription
            AppLogger.error(error, category: .auth)
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
        DIContainer.shared.reset()
        userIsLoggedIn = false
        userEmail = ""
        userPassword = ""
    }

    // MARK: - Validation

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
