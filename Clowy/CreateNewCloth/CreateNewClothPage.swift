//
//  CreateNewClothPage.swift
//  Clowy
//
//  Created by Егор Карпухин on 01.11.2024.
//

import SwiftUI

struct CreateNewClothPage<Content: View>: View {
    @StateObject var viewModel = OnboardingQuizViewModel.shared
    let size: CGSize
    var index: Int
    let title: String
    
    let content: Content
    
    init(size: CGSize, index: Int, title: String, @ViewBuilder content: () -> Content) {
        self.size = size
        self.index = index
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.custom("Montserrat-Bold", size: 24))
                    .foregroundStyle(Color(hex: "#646C75"))
                Spacer()
            }
            .padding(.bottom, 16)
            .padding(.horizontal, 24)
            
            content
                .padding(.horizontal, 24)
            
            Spacer()
        }
        .padding(.top, 12)
    }
}
