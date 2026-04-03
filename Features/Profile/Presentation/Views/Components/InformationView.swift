//
//  InformationView.swift
//  Clowy
//
//  Created by Егор Карпухин on 14.07.2022.
//

import SwiftUI

struct InformationView: View {
    @State var showOnboarding = false
    var versionNumber = "1.0.0"
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            VStack (alignment: .leading, spacing: 16){
                Text("Privacy policy")
                    .foregroundColor(Color.primaryGrey)
                    .font(.custom("Montserrat-Medium", size: 16))
                Rectangle()
                    .foregroundColor(Color.separatorGrey)
                    .frame(height: 1)
                
                Text("Documents")
                    .foregroundColor(Color.primaryGrey)
                    .font(.custom("Montserrat-Medium", size: 16))
                Rectangle()
                    .foregroundColor(Color.separatorGrey)
                    .frame(height: 1)
                
                Button {
                    showOnboarding.toggle()
                } label: {
                    Text("Onboarding")
                        .foregroundColor(Color.primaryGrey)
                        .font(.custom("Montserrat-Medium", size: 16))
                }
                .sheet(isPresented: $showOnboarding) {
                    OnboardingQuiz()
                        .padding(.top, 8)
                }
                Rectangle()
                    .foregroundColor(Color.separatorGrey)
                    .frame(height: 1)
                
                HStack {
                    Text("About the application")
                        .foregroundColor(Color.primaryGrey)
                        .font(.custom("Montserrat-Medium", size: 16))
                    Spacer()
                    Text(versionNumber)
                        .foregroundColor(Color.primaryGrey)
                        .font(.custom("Montserrat-Medium", size: 16))
                }
                
            }
            .padding(16)
        }
        .shadow(color: Color.shadowGrey.opacity(0.1), radius: 35, x: 0, y: 8)
    }
}
