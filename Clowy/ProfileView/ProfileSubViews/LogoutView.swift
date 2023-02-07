//
//  LogoutButton.swift
//  Clowy
//
//  Created by Егор Карпухин on 07.02.2023.
//

import SwiftUI

struct LogoutView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            HStack {
                Text("Log out")
                    .foregroundColor(Color(hex: "#646C75"))
                    .font(.custom("Montserrat-Medium", size: 16))
                Spacer()
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color(hex: "#646C75"))
            }
            .padding(16)
        }
    }
}
