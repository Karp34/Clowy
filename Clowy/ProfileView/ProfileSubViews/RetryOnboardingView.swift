//
//  RetryOmboardingView.swift
//  Clowy
//
//  Created by Егор Карпухин on 07.08.2024.
//

import SwiftUI

struct RetryOnboardingView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.font : UIFont(name: "Montserrat-Bold", size: 14)!]
        UINavigationBar.appearance().titleTextAttributes = [.font : UIFont(name: "Montserrat-Bold", size: 14)!, .foregroundColor: UIColor(Color(hex: "#FFFFFF"))]
        navBarAppearance.backgroundColor = UIColor(Color(hex: "#F7F8FA"))
        navBarAppearance.shadowColor = .clear
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
    }
    
    var btnBack : some View {
        Button {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Image("back_button")
                .aspectRatio(contentMode: .fit)
                .frame(width: 12, height: 12.0).contentShape(Rectangle())
                .foregroundColor(.black)
        }
    }
    var body: some View {
        OnboardingQuiz()
            .navigationBarTitle("Onboarding")
            .navigationBarHidden(false)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: btnBack)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                
            }
    }
        
}
