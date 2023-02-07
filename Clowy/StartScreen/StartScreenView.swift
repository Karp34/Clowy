//
//  StartScreenView.swift
//  Clowy
//
//  Created by Егор Карпухин on 16.09.2022.
//

import SwiftUI

struct StartScreenView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(hex: "#678CD4"))
                .edgesIgnoringSafeArea(.all)
            Text("Clowy")
                .font(Font.custom("Montserrat-Regular", size: 28))
                .foregroundColor(Color(hex: "#FFFFFF"))
        }
        .frame(width: .infinity, height: .infinity)
    }
}

struct StartScreenView_Previews: PreviewProvider {
    static var previews: some View {
        StartScreenView()
    }
}
