//
//  TemperaturePreferenceDressing.swift
//  Clowy
//
//  Created by Егор Карпухин on 19.08.2024.
//

import SwiftUI

struct TemperaturePreferenceDressing: View {
    @StateObject private var mainViewModel = MainScreenViewModel.shared
    @State var selectedItem: String = ""
    let options = ["Cooler", "Normal", "Warmer"]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            VStack(alignment:.leading, spacing: 16) {
                Text("You prefer to dress:")
                    .foregroundColor(Color.primaryGray)
                    .font(.custom("Montserrat-Medium", size: 16))
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(
                            selectedItem == "Warmer" ? Color.primaryOrangeBrand : selectedItem == "Cooler" ? Color.secondaryBlueBrand : Color.secondaryGray
                        )
                    Picker("What is your preference for dressing?", selection: $selectedItem) {
                        ForEach(options, id: \.self) {
                            Text($0)
                                .font(.custom("Montserrat-Regular", size: 14))
                                .foregroundStyle(selectedItem == $0 ? Color.black : Color.white)
                        }
                    }
                    .pickerStyle(.segmented)
                    .foregroundStyle(.clear)
                    .background(.clear)
                    .onAppear{
                        selectedItem = mainViewModel.user.config
                    }
                    .onChange(of: selectedItem) {
                        mainViewModel.user.config = selectedItem
                        mainViewModel.updateUser { error in
                            if let error = error {
                                print(error.description)
                            }
                        }
                    }
                    .onChange(of: mainViewModel.user.config) {
                        selectedItem = mainViewModel.user.config
                    }
                }
            }
            .padding(16)
        }
        .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
    }
}
