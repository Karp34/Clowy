//
//  SplashScreen.swift
//  Clowy
//
//  Created by Егор Карпухин on 16.12.2022.
//

import SwiftUI

struct SplashScreen: View {
    @StateObject private var viewModel = MainScreenViewModel.shared
    @State var size = 0.8
    @State var opacity = 0.5
    @State var isActive = false
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        if isActive {
            if viewModel.userIsLoggedIn {
                MainScreenView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .preferredColorScheme(.light)
            } else {
                LoginScreen()
            }
        } else {
            VStack {
                ZStack {
                    Color(hex: "#5987DD")
                        .edgesIgnoringSafeArea(.all)
                    Text("Clowy")
                        .font(.custom("Montserrat-SemiBold", size: 48))
                        .foregroundColor(.white)
                
                }
            }
            .background(Color(hex: "#5987DD").edgesIgnoringSafeArea(.all))
            .onAppear {
                withAnimation {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0 ) {
                        self.isActive = true
                    }
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
