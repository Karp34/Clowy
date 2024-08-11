//
//  ProfileNavBarView.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.07.2022.
//

import SwiftUI


struct ProfileNavBarView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var viewModel: ProfileViewModel
    @State var isChangingName = false
    
    var btnBack : some View {
        Button (action: {
            self.presentationMode.wrappedValue.dismiss()}) {
                ZStack {
                    Image("back_button")
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 12.0, height: 12.0)
                        .foregroundColor(.white)
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 20, height: 25)
                }
            }
    }
    
    let hint = "Enter your name"
    
    let insets = EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
    
    var body: some View {
        VStack {
            HStack(spacing: 8) {
                HStack {
                    btnBack
                    Spacer()
                }
                .frame(width: 120)
                Spacer()
                Text("Profile")
                    .font(.custom("Montserrat-Bold", size: 14))
                    .foregroundColor(.white)
                Spacer()
                HStack {
                }
                .frame(width: 120)
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)
        }
        
        .foregroundColor(Color(hex: "#678CD4"))
        .background(Color(hex: "#678CD4")
            .frame(height: 124)
            .edgesIgnoringSafeArea(.all)
            .offset(y: -20))
    }
}
