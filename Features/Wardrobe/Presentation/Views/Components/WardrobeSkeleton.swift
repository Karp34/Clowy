//
//  WardrobeSkeleton.swift
//  Clowy
//
//  Created by Егор Карпухин on 03.04.2026.
//


import SwiftUI

struct WardrobeSkeleton: View {
    var body: some View {
        ForEach(0..<6, id: \.self) { _ in
            WardrobeCategorySkeleton()
        }
    }
}