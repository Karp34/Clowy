//
//  NewClothView.swift
//  FirebaseApp
//
//  Created by Егор Карпухин on 15.10.2022.
//

import SwiftUI

struct NewClothView: View {
    @State private var isShowingSheet = false
    
    var body: some View {
        Button(action: {
            isShowingSheet.toggle()
        })
        {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color(hex: "##DADADA"), lineWidth: 1)
                    .frame(width: 128, height: 164)
                Image(systemName: "plus")
                    .foregroundColor(Color(hex: "##DADADA"))
                    .frame(height: 14)
            }
        }
    }
}
