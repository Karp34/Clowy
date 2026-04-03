//
//  TemperaturePreferenceDressing.swift
//  Clowy
//
//  Created by Егор Карпухин on 19.08.2024.
//
import SwiftUI

struct TemperaturePreferenceDressing: View {
    @EnvironmentObject var profileViewModel: ProfileViewModel
    @State var selectedItem: String = ""
    let options = ["Cooler", "Normal", "Warmer"]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16).foregroundColor(.white)
            VStack(alignment: .leading, spacing: 16) {
                Text("You prefer to dress:")
                    .foregroundColor(Color.primaryGrey)
                    .font(.custom("Montserrat-Medium", size: 16))
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(
                            selectedItem == "Warmer" ? Color.primaryOrangeBrand :
                            selectedItem == "Cooler" ? Color.secondaryBlueBrand : Color.secondaryGrey
                        )
                    Picker("What is your preference for dressing?", selection: $selectedItem) {
                        ForEach(options, id: \.self) {
                            Text($0).font(.custom("Montserrat-Regular", size: 14))
                        }
                    }
                    .pickerStyle(.segmented)
                    .onAppear { selectedItem = profileViewModel.user.config }
                    .onChange(of: selectedItem) {
                        profileViewModel.user.config = selectedItem
                        Task { await profileViewModel.updateUser() }
                    }
                    .onChange(of: profileViewModel.user.config) {
                        selectedItem = profileViewModel.user.config
                    }
                }
            }
            .padding(16)
        }
        .shadow(color: Color.shadowGrey.opacity(0.1), radius: 35, x: 0, y: 8)
    }
}
