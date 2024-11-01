//
//  ProfileView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI


class ProfileViewModel: ObservableObject {
    @Published var chosenClothes: [String] = UserDefaults.standard.array(forKey: "chosenClothesTypes") as? [String] ?? GetChosenClothes.getChosenClothes()[1].clothes
    @Published var location = UserDefaults.standard.string(forKey: "location") ?? "New York"
    
    static var shared = ProfileViewModel()
}

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel.shared
    @StateObject private var mainViewModel = MainScreenViewModel.shared
    
    @State var showSheet = false
    @State var showSheet2 = false
    @State var showSheet3 = false
    @State private var showingAlert = false
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack (spacing: 24){
                    Spacer(minLength: 180)
//                    TempPreferenceView()
                    TemperaturePreferenceDressing()
                    
                    Button {
                        showSheet.toggle()
                    } label: {
                        LocationView()
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .sheet(isPresented: $showSheet) {
                        ChooseLocationView()
                    }
                    
//                    AvailableTypesView()
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
                            primaryButton:  .default(Text("Yes")) {
                                withAnimation {
                                    mainViewModel.signOut()
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                        mainViewModel.userIsLoggedIn = false
                                        mainViewModel.clearViewModel()
                                    }
                                }
                                print("Logout")
                            },
                            secondaryButton:  .default(Text("Cancel")) {
                                print("Cancel")
                            }
                        )
                    }
                    
                    Button {
                        showSheet2.toggle()
                    } label: {
                        Text("LocationView")
                    }
                    .sheet(isPresented: $showSheet2) {
                        NewLocationView()
                    }
                    
                    
                    Button("Create New Cloth") {
                        mainViewModel.showAddNewClothModel.toggle()
                    }
                    .fullScreenCover(isPresented: $mainViewModel.showAddNewClothModel) {
                        CreateNewClothView()
                    }
                    
                    
                }
                .padding(.horizontal, 24)
            }
            VStack (spacing: 8) {
                ProfileNavBarView(viewModel: viewModel)
                ProfileNavBarContent()
            }
        }
        .navigationBarHidden(true)
        .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
    }
}
