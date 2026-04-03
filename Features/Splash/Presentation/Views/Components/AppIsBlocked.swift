//
//  AppIsBlocked.swift
//  Clowy
//
//  Created by Egor Karpukhin on 30/12/2023.
//
import SwiftUI

struct AppIsBlocked: View {
    var body: some View {
        ZStack {
            Color.primaryBlueBrand.ignoresSafeArea()
            Text(RemoteConfigManager.shared.stringValue(forKey: RCKey.appIsBlockedReason))
                .font(.custom("Montserrat-Regular", size: 24))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
        }
    }
}
