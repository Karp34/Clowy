//
//  WelcomeView.swift
//  Clowy
//
//  Created by Егор Карпухин on 19.09.2022.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack {
            VStack {
                Text("Welcome")
                Text("Share location")
                Button {
                    locationManager.requestLocation()
                } label: {
                    Text("Share location")
                        .foregroundColor(.blue)
                }
            }
            .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
