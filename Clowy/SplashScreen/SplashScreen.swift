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
    @State var offset: CGFloat = 300
    @State var isActive = false
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        GeometryReader { geometry in
            if isActive {
                if viewModel.userIsLoggedIn {
                    MainScreenView()
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .preferredColorScheme(.light)
                } else {
    //                TestLoginScreen()
                    LoginScreen()
                }
            } else {
                let textOffset = geometry.size.height/2
                ZStack(alignment: .bottom) {
                    ZStack(alignment: .top) {
                        Color(hex: "#678CD4")
                        Text("Clowy")
                            .font(.custom("Montserrat-Bold", size: 40))
                            .foregroundColor(.white)
                            .padding(.top, textOffset)
    //                        .background(Color.red)
                    }
//                    Text("Dress smarter. Look better.")
//                        .font(.custom("Montserrat-Medium", size: 14))
//                        .foregroundColor(.white)
//                        .padding(.bottom, 50)
                    Text("Dress smarter. Look better.")
                        .font(.custom("Montserrat-Medium", size: 14))
                        .foregroundColor(.white)
                        .padding(.bottom, 38)
                }
                
                .ignoresSafeArea(.all)
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
