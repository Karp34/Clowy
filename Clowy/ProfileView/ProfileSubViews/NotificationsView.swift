//
//  NotificationsView.swift
//  Clowy
//
//  Created by Егор Карпухин on 14.07.2022.
//

import SwiftUI

struct NotificationsView: View {
    @State private var showGreeting = true
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            Toggle(isOn: $showGreeting, label: {
                Text("Notifications")
                    .foregroundColor(Color(hex: "#646C75"))
                    .font(.custom("Montserrat-Medium", size: 16))
            })
            .padding(16)
        }
        .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
