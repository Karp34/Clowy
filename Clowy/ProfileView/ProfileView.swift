//
//  ProfileView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI

struct ProfileView: View {
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
            ProfileNavBarView()
        }
    }
}
