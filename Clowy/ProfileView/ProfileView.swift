//
//  ProfileView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    
    static var shared = ProfileViewModel()
}

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel.shared
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack (spacing: 24){
                    Spacer(minLength: 180)
                    TempPreferenceView()
                    LocationView()
                    AvailableTypesView()
                    NotificationsView()
                    InformationView()
                }
                .padding(.horizontal, 24)
            }
            VStack (spacing: 8){
                ProfileNavBarView()
                ProfileNavBarContent()
            }
        }
    }
}
