//
//  SplashScreen.swift
//  Clowy
//
//  Created by Егор Карпухин on 16.12.2022.
//
import SwiftUI

struct SplashScreen: View {
    @StateObject private var authRouter = AuthRouter()
    @StateObject private var mainViewModel = DIContainer.shared.makeMainScreenViewModel()
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            if authRouter.appIsLive {
                if authRouter.userIsLoggedIn {
                    if authRouter.didOnboarding {
                        MainScreenView(viewModel: mainViewModel)
                            .environmentObject(mainViewModel)
                    } else {
                        OnboardingQuiz()
                    }
                } else {
                    LoginScreen(onLoginSuccess: {
                        authRouter.userIsLoggedIn = true
                        authRouter.didOnboarding = false
                    })
                }
            } else {
                AppIsBlocked()
            }
        } else {
            SunSplachScreen()
                .onAppear {
                    Task {
                        await authRouter.checkAuthState()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                            self.isActive = true
                        }
                    }
                }
        }
    }
}
