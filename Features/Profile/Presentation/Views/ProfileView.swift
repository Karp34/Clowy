//
//  ProfileView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var mainViewModel: MainScreenViewModel

    @State var showSheet = false
    @State var showSheet2 = false
    @State private var showingAlert = false
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    Spacer(minLength: 180)

                    TemperaturePreferenceDressing()

                    Button {
                        showSheet.toggle()
                    } label: {
                        LocationView(chosenWeather: mainViewModel.chosenWeather)
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .sheet(isPresented: $showSheet) {
                        ChooseLocationView()
                    }

                    AvailableTypesView()

                    NotificationsView()
                    InformationView()

                    Button {
                        showingAlert = true
                    } label: {
                        LogoutView()
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Logout"),
                            message: Text("Do you want to log out?"),
                            primaryButton: .default(Text("Yes")) {
                                try? viewModel.signOut()
                            },
                            secondaryButton: .default(Text("Cancel"))
                        )
                    }

                    Button { showSheet2.toggle() } label: { Text("LocationView") }
                        .sheet(isPresented: $showSheet2) { ChooseLocationView() }
                }
                .padding(.horizontal, 24)
            }
            VStack(spacing: 8) {
                ProfileNavBarView(viewModel: viewModel)
                ProfileNavBarContent()
            }
        }
        .environmentObject(viewModel)
        .navigationBarHidden(true)
        .background(Color.primaryBackground.edgesIgnoringSafeArea(.all))
        .task { await viewModel.loadUser() }
    }
}
