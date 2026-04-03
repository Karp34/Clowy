//
//  AddClothButton.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI

struct AddClothButton: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.separatorGrey, lineWidth: 1)
                .frame(width: 128, height: 164)
            Image(systemName: "plus")
                .foregroundColor(Color.separatorGrey)
                .frame(height: 14)
        }
    }
}