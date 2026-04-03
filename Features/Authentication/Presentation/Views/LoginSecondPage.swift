//
//  LoginSeconPage.swift
//  Clowy
//
//  Created by Егор Карпухин on 12.02.2023.
//
import SwiftUI

struct LoginSecondPage: View {
    @EnvironmentObject var viewModel: LoginViewModel

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    withAnimation { viewModel.showSecondPage = false }
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color.primaryBackground)
                        Image("back_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                            .foregroundColor(Color.primaryGrey)
                    }
                }
                Spacer()
                Text("Confirm email")
                    .font(.custom("Montserrat-Bold", size: 24))
                    .foregroundColor(Color.primaryGrey)
                Spacer()
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 12, height: 12)
            }
            .padding(.top, 24)
            .padding(.horizontal, 24)
            .padding(.bottom, 72)

            VStack(alignment: .center, spacing: 16) {
                ZStack {
                    Circle()
                        .frame(width: 96, height: 96)
                        .foregroundColor(Color.primaryBlueBrand)
                        .opacity(0.2)
                    Image(systemName: "envelope")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .foregroundColor(Color.primaryBlueBrand)
                }
                Text("An email has been sent. Follow the link in the email to confirm your email address")
                    .font(.custom("Montserrat-Regular", size: 16))
                    .foregroundColor(Color.primaryGrey)
                    .multilineTextAlignment(.center)
                    .frame(height: 72)
            }
            .frame(idealHeight: 320)

            Spacer(minLength: 153)
        }
        .frame(height: 565)
        .background(Color.primaryBackground)
    }
}
