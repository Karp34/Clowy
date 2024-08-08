//
//  ClowyApp.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.11.2021.
//

import SwiftUI
import Firebase

@available(iOS 17.0, *)
@main

struct Clowy2App: App {
    
//    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .preferredColorScheme(.light)
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background:
                print("Scene is in background")
//                persistenceController.save()
            case .inactive:
                print("Scene is inactive")
            case .active:
                print("Scene is active")
            @unknown default:
                print("Apple must have changed something")
            }
        }
    }
}
