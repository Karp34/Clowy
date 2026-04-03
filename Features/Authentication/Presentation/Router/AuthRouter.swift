//
//  AuthRouter.swift
//  Clowy
//
//  Created by Егор Карпухин on 21.03.2026.
//

import SwiftUI
import Firebase

@MainActor
final class AuthRouter: ObservableObject {

    @Published var userIsLoggedIn: Bool = false
    @Published var didOnboarding: Bool = false
    @Published var isReady: Bool = false
    @Published var appIsLive: Bool = true

    func checkAuthState() async {
        appIsLive = RemoteConfigManager.shared.stringValue(forKey: RCKey.appIsLive) == "true"

        await withCheckedContinuation { continuation in
            Auth.auth().addStateDidChangeListener { auth, user in
                Task { @MainActor in
                    if let user {
                        DIContainer.shared.setup(userId: user.uid)
                        do {
                            let profile = try await DIContainer.shared.profileRepository!.getUserInfo()
                            self.didOnboarding = profile.didOnboarding
                            self.userIsLoggedIn = true
                        } catch {
                            AppLogger.error(error, category: .auth)
                            self.userIsLoggedIn = false
                        }
                    } else {
                        self.userIsLoggedIn = false
                    }
                    continuation.resume()
                }
            }
        }
    }

    func signOut() {
        try? Auth.auth().signOut()
        DIContainer.shared.reset()
        userIsLoggedIn = false
        didOnboarding = false
    }
}
