//
//  AppIsBlocked.swift
//  Clowy
//
//  Created by Egor Karpukhin on 30/12/2023.
//

import SwiftUI

struct AppIsBlocked: View {
    @StateObject private var viewModel = MainScreenViewModel.shared
    
    var body: some View {
        Text(viewModel.appIsLive)
        Button {
            viewModel.appIsLive = "true"
        } label: {
            Text("Change to true")
        }
        Text(viewModel.NormalSuperColdConfig.name)
        Text(viewModel.NormalSuperColdConfig.weatherConfig[0].clothes.debugDescription)

    }
}
