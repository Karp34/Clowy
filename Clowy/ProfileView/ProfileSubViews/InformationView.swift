//
//  InformationView.swift
//  Clowy
//
//  Created by Егор Карпухин on 14.07.2022.
//

import SwiftUI

struct InformationView: View {
    var versionNumber = "1.0.0"
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.white)
            VStack (alignment: .leading, spacing: 16){
                NavigationLink {
//                    ColorImagesView()
////                        .foregroundColor(.red)
                } label: {
                    Text("Privacy policy")
                        .foregroundColor(Color(hex: "#646C75"))
                        .font(.custom("Montserrat-Medium", size: 16))
                }

//                Text("Privacy policy")
//                    .foregroundColor(Color(hex: "#646C75"))
//                    .font(.custom("Montserrat-Medium", size: 16))
                Rectangle()
                    .foregroundColor(Color(hex: "#DADADA"))
                    .frame(height: 1)
                Text("Documents")
                    .foregroundColor(Color(hex: "#646C75"))
                    .font(.custom("Montserrat-Medium", size: 16))
                Rectangle()
                    .foregroundColor(Color(hex: "#DADADA"))
                    .frame(height: 1)
                HStack {
                    Text("About the application")
                        .foregroundColor(Color(hex: "#646C75"))
                        .font(.custom("Montserrat-Medium", size: 16))
                    Spacer()
                    Text(versionNumber)
                        .foregroundColor(Color(hex: "#646C75"))
                        .font(.custom("Montserrat-Medium", size: 16))
                }
                
            }
            .padding(16)
        }
        .shadow(color: Color(hex: "#273145").opacity(0.1), radius: 35, x: 0, y: 8)
    }
}

struct InformationView_Previews: PreviewProvider {
    static var previews: some View {
        InformationView()
    }
}
