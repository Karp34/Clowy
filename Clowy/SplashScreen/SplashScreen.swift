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
//    @State var offset: CGFloat = 300
    @State var isActive = false
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
//        GeometryReader { geometry in
            if isActive {
                if viewModel.userIsLoggedIn {
                    
                    if viewModel.appIsLive == "false" {
                        AppIsBlocked()
                    } else {
                        MainScreenView()
                            .environment(\.managedObjectContext, persistenceController.container.viewContext)
                            .preferredColorScheme(.light)
                    }
                } else {
                    LoginScreen()
                }
            } else {
                SunSplachScreen()
                .onAppear {
                    if UserDefaults.standard.bool(forKey: "launchedBefore") {
                        viewModel.getCoordinates()
                        viewModel.observeDeniedLocationAccess()
                        viewModel.deviceLocationService.requestLocationUpdates()
                        
                        viewModel.getUserId()
                        viewModel.fetchWardrobe() {}
                        viewModel.fetchOutfits()
                    }
                    Auth.auth().addStateDidChangeListener { auth, user in
                        if user != nil {
                            viewModel.userIsLoggedIn.toggle()
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.5 ) {
                        self.isActive = true
                    }
                }
            }
//        } geometry
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
