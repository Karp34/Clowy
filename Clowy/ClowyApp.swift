//
//  ClowyApp.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.11.2021.
//

import SwiftUI

@available(iOS 14.0, *)
@main

struct Clowy2App: App {
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            MainScreenView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .background:
                print("Scene is in background")
                persistenceController.save()
            case .inactive:
                print("Scene is inactive")
            case .active:
                print("Scene is active")
            @unknown default:
                print("Apple musc have changed something")
            }
        }
    }
}