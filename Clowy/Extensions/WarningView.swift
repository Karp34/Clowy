//
//  WarningView.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 08.11.2022.
//

import SwiftUI

struct WarningView: View {
    var image: Image?
    var title: String?
    var subtitle: String?
    var color: String = "#B1B4B8"
    
    
    var body: some View {
        VStack(spacing: 8) {
            if let image = image {
                ZStack {
                    Circle()
                        .foregroundColor(Color(hex: color)).opacity(0.2)
                        .frame(width: 96, height: 96)
                    image
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(hex: color))
                        .frame(width: 54, height: 54)
                }
                .padding(.bottom, 8)
            }
            if let title = title {
                Text(title)
                    .font(.custom("Montserrat-Regular", size: 20))
                    .foregroundColor(Color(hex: "#646C75"))
                    .frame(width: 279)
            }
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(.custom("Montserrat-Regular", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#646C75"))
                    .frame(width: 279)
            }
        }
    }
}

struct WarningView_Previews: PreviewProvider {
    static var previews: some View {
        WarningView(image: Image(systemName: "exclamationmark.circle.fill"), title: "No clothing sets", subtitle: "Here you can create a set of clothes for any purpose and weather")
    }
}
