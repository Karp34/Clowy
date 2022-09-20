//
//  LocationView.swift
//  Clowy
//
//  Created by Егор Карпухин on 19.09.2022.
//

import SwiftUI
import CoreLocationUI

struct NewLocationView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                Text("Your coord are : \(location.longitude), \(location.latitude)")
            } else {
                 if locationManager.isLoading {
                     ProgressView()
                 } else {
                         WelcomeView()
                             .environmentObject(locationManager)
                             
                     }
                 }
            }
            .background(Color.green)
            .preferredColorScheme(.dark)
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
