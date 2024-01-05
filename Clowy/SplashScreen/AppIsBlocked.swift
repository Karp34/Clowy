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
        ZStack{
            Color(hex: "#678CD4")
                .ignoresSafeArea()
            Text(RemoteConfigManager.stringValue(forKey: RCKey.appIsBlockedReason))
                .font(.custom("Montserrat-Regular", size: 24))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "#FFFFFF"))
                .padding(.horizontal, 24)
//            VStack {
//                Spacer()
//                Button {
//                    viewModel.appIsLive = "true"
//                } label: {
//                    Text("Change to true")
//                }
//            }
        }
    }
}
