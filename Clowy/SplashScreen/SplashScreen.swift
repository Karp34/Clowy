//
//  SplashScreen.swift
//  Clowy
//
//  Created by Егор Карпухин on 16.12.2022.
//

import SwiftUI
import Firebase

struct SplashScreen: View {
    @StateObject private var viewModel = MainScreenViewModel.shared
    @State var size = 0.8
    @State var isActive = false
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        if isActive {
            if viewModel.appIsLive == "true" {
                if viewModel.userIsLoggedIn {
                    if viewModel.user.didOnboarding {
                        MainScreenView()
                    } else {
                        OnboardingQuiz()
                    }
                } else {
                    LoginScreen()
                }
            } else {
                AppIsBlocked()
            }
        } else {
            SunSplachScreen()
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if let user {
                        viewModel.userId = user.uid
                        viewModel.userIsLoggedIn = true
                        viewModel.getUserInfo {
                            if viewModel.user.id != "" {
                                viewModel.fetchWardrobe() {}
                                viewModel.fetchOutfits()
                            }
                        }
                    }
                }
                viewModel.getCoordinates()
                viewModel.observeDeniedLocationAccess()
                viewModel.deviceLocationService.requestLocationUpdates()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5 ) {
                    self.isActive = true
                }
               
                
//                if UserDefaults.standard.bool(forKey: "launchedBefore") {
//                    viewModel.getCoordinates()
//                    viewModel.observeDeniedLocationAccess()
//                    viewModel.deviceLocationService.requestLocationUpdates()
//                    
//                    
//                    viewModel.fetchWardrobe() {}
//                    viewModel.fetchOutfits()
//                }
            }
        }
    }
}
