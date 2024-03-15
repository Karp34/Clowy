//
//  AvatarCarousel.swift
//  Clowy
//
//  Created by Егор Карпухин on 14.03.2024.
//

import SwiftUI

struct AvatarCarousel: View {
    let emojiList = GetEmojis.getEmojis()
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 0) {
                ForEach(emojiList, id: \.self) { emoji in
                    Image(emoji.icon)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle(cornerRadius: 25.0))
                        .padding(.horizontal, 20)
 
                }
            }
        }
        .scrollTargetBehavior(.paging)
    }
}
