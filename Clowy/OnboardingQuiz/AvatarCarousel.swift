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
                        .clipShape(Circle())
                        .padding(.horizontal, 20)
 
                }
            }
        }
        .scrollTargetBehavior(.paging)
    }
}

import SwiftUI

struct EmojiCarousel: View {
    let emojis: [String] // Array of emojis
    @Binding var selectedEmoji: String // Currently selected emoji
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(emojis, id: \.self) { emoji in
                    GeometryReader { geometry in
                        EmojiCircleView(emoji: emoji)
                            .onAppear {
                                if abs(geometry.frame(in: .global).midX - UIScreen.main.bounds.midX) < 50 {
                                    selectedEmoji = emoji
                                }
                            }
                    }
                    .frame(width: 60, height: 60) // Assuming each emoji circle has a fixed size
                }
            }
            .padding()
        }
    }
}

struct EmojiCircleView: View {
    let emoji: String
    
    var body: some View {
        Text(emoji)
            .font(.largeTitle)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Circle())
    }
}

struct EmojiCarouselView: View {
    let emojis = ["😀", "😎", "😂", "😊", "🥳", "😍", "🤔"] // Example emojis
    
    @State private var selectedEmoji = "" // Currently selected emoji
    
    var body: some View {
        VStack {
            Text("Selected Emoji: \(selectedEmoji)")
                .font(.title)
                .padding()
            
            EmojiCarousel(emojis: emojis, selectedEmoji: $selectedEmoji)
        }
    }
}
