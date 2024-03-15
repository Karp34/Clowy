//
//  WideSlider.swift
//  Clowy
//
//  Created by Егор Карпухин on 14.03.2024.
//

import SwiftUI

struct WideSliderView: View {
    @State var sliderconfig: WideSliderConfig = .init()
    @Namespace private var namespace
    let totalPages: CGFloat = 10
    @State var currentPage: CGFloat = 1
    
    var body: some View {
        VStack {
            ProgressBarQuiz(totalPages: totalPages, currentPage: currentPage)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1.5)) {
                        if currentPage < totalPages {
                            currentPage += 1
                        } else {
                            currentPage -= 9
                        }
                    }
                }
            Color.clear.frame(height: 40)
            AvatarCarousel()
            Color.clear.frame(height: 40)
            WideSlider(animationID: "EXPAND", namespacelD: namespace, config: $sliderconfig)
                .frame(width: 124, height: 336)
            Color.clear
        }
        .padding(.top, 8)
        .padding(.horizontal, 24)
        .background(Color.primaryBackground.ignoresSafeArea())
    }
}


struct degreeScale: View {
    @Binding var config: WideSliderConfig
    
    var body: some View {
        VStack(spacing: 65) {
            Text("0°C")
                .font(.custom("Montserrat-Bold", size: 16))
                .foregroundColor(config.progress > 0.75 ? Color.white : Color.primaryBlueBrand)
            
            Text("-10°C")
                .font(.custom("Montserrat-Bold", size: 16))
                .foregroundColor(config.progress > 0.5 ? Color.white : Color.primaryBlueBrand)
            
            Text("-20°C")
                .font(.custom("Montserrat-Bold", size: 16))
                .foregroundColor(config.progress > 0.25 ? Color.white : Color.primaryBlueBrand)
        }
    }
}

struct WideSlider: View {
    var animationID: String
    var cornerRadius: CGFloat = 20
    var namespacelD: Namespace.ID
    @Binding var config: WideSliderConfig
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            ZStack {
                Rectangle()
                    .fill(Color(hex: "#E6EEFF"))
                    .overlay (alignment: .bottom) {
                        Rectangle ()
                            .fill(Color.secondaryBlueBrand)
                            .scaleEffect (y: config.progress, anchor: .bottom)
                    }
                    .overlay {
                        degreeScale(config: $config)
                    }
                    .clipShape (RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                    .matchedGeometryEffect(id: animationID, in: namespacelD)
                    .gesture( DragGesture().onChanged({ value in
                        if !config.shrink {
                            let startLocation = value.startLocation.y
                            let currentLocation = value.location.y
                            let offset = startLocation - currentLocation
                            var progress = (offset / size.height) + config.lastProgress
                            progress = max(0, progress)
                            progress = min(1, progress)
                            config.progress = progress
                        }
                    }).onEnded({ value in
                        config.lastProgress = config.progress
                    }))
                
            }
        }
    }
}

struct WideSliderConfig {
    var shrink: Bool = false
    var expand: Bool = false
    var showContent: Bool = false
    var progress: CGFloat = 0.7
    var lastProgress: CGFloat = 0.7
}
