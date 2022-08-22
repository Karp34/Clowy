//
//  SuperChildView.swift
//  Clowy
//
//  Created by Егор Карпухин on 30.06.2022.
//

import SwiftUI

struct SuperChildView: View {
    let number: Int
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundColor(.red)
            Text(String(number))
        }
    }
}
