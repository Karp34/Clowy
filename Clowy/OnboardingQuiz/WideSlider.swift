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
    let questionIndex: Int
    
    var body: some View {
            WideSlider(animationID: "EXPAND", namespacelD: namespace, config: $sliderconfig, questionIndex: questionIndex)
            .frame(width: 124, height: 336)
    }
}


struct degreeScale: View {
    @Binding var config: WideSliderConfig
    
    var body: some View {
        ZStack {
            VStack {
                
            }
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
}

struct WideSlider: View {
    @StateObject var viewModel = OnboardingQuizViewModel.shared
    var animationID: String
    var cornerRadius: CGFloat = 20
    var namespacelD: Namespace.ID
    @Binding var config: WideSliderConfig
    let questionIndex: Int
    
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
                        viewModel.questions[questionIndex-1].answer = getPreference(progress: config.progress)
                    }))
                
            }
        }
    }
    
    func getPreference(progress: CGFloat) -> [String] {
        var result: [String] = []
        
        switch progress {
        case _ where progress < 0.375:
            result = ["-20°C and below"]
        case _ where progress < 0.625:
            result = ["-10°C and below"]
        case _ where progress <= 0.875:
            result = ["0°C and below"]
        case _ where progress > 0.875:
            result = ["0°C and above"]
        default:
            result = ["0°C and below"]
        }
        
        return result
    }
}

struct WideSliderConfig {
    var shrink: Bool = false
    var expand: Bool = false
    var showContent: Bool = false
    var progress: CGFloat = 0.7
    var lastProgress: CGFloat = 0.7
}
