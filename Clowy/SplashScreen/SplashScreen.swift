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
                    if viewModel.didOnboarding {
                        MainScreenView()
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                            .preferredColorScheme(.light)
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
                if UserDefaults.standard.bool(forKey: "launchedBefore") {
                    viewModel.getCoordinates()
                    viewModel.observeDeniedLocationAccess()
                    viewModel.deviceLocationService.requestLocationUpdates()
                    
                    
                    viewModel.fetchWardrobe() {}
                    viewModel.fetchOutfits()
                    
                }
                Auth.auth().addStateDidChangeListener { auth, user in
                    if let user {
                        viewModel.userId = user.uid
                        viewModel.userIsLoggedIn.toggle()
                        
                        viewModel.getUserInfo {
                            if !viewModel.user.config.isEmpty {
                                viewModel.didOnboarding = true
                            }
                        }
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5 ) {
                    self.isActive = true
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
