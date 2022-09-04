//
//  AvatarView.swift
//  Clowy
//
//  Created by Егор Карпухин on 18.11.2021.
//

import SwiftUI

struct AvatarIcon: View {
    var avatar: String
    var color: String
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 48.0, height: 48.0)
                .foregroundColor(Color(hex: color))
                .opacity(0.2)
            Image(avatar)
                .resizable()
                .scaledToFit()
                .frame(width: (avatar.starts(with: "memoji") ? 37 : 30), height: (avatar.starts(with: "memoji") ? 37 : 30))
        }
    }
}
