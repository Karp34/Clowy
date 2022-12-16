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
    
    @State var showSheet = false
    @State var showSheet2 = false
    
    var body: some View {
        ZStack(alignment: .top) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack (spacing: 24){
                    Spacer(minLength: 180)
                    TempPreferenceView()
                    
                    Button {
                        showSheet.toggle()
                    } label: {
                        LocationView()
                    }
                    .buttonStyle(ScaleButtonStyle())
                    .sheet(isPresented: $showSheet) {
                        ChooseLocationView()
                    }
                    
                    AvailableTypesView()
                    NotificationsView()
                    InformationView()
                    
                    Button {
                        showSheet2.toggle()
                    } label: {
                        Text("LocationView")
                    }
                    .sheet(isPresented: $showSheet2) {
                        NewLocationView()
                    }
                }
                .padding(.horizontal, 24)
            }
            VStack (spacing: 8){
                ProfileNavBarView(viewModel: viewModel)
                ProfileNavBarContent()
            }
        }
        .onAppear {
            UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        }
        .background(Color(hex: "#F7F8FA").edgesIgnoringSafeArea(.all))
    }
}
