//
//  ColorImagesView.swift
//  Clowy
//
//  Created by Егор Карпухин on 07.10.2022.
//

import SwiftUI

struct ColorImagesView: View {
    @StateObject private var viewModel = MainScreenViewModel.shared
    @State private var scaleValue = CGFloat(1)
    @State var isShow = false
    
    @State var selection: Int? = nil
    
    var body: some View {
        
        
        VStack {
            NavigationLink(destination: NewWardrobeScreen(), tag: 1, selection: $selection) {
                Button(action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.selection = 1
                    }
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .foregroundColor(.blue)
                            .frame(width: 400, height: 32)
                        Text("Add")
                            .font(.custom("Montserrat-Bold", size: 16))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(NoAnimationButtonStyle())
            }
            .buttonStyle(ScaleButtonStyle())
            
            HStack {
                Color(hex: "#678CD4")
                Color(hex: "#425987")
            }
            
            Button {
                
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                    Text("Add")
                        .font(.custom("Montserrat-Bold", size: 16))
                        .foregroundColor(.white)
                }
                
            }
            .padding(.bottom, 24)
            .buttonStyle(DefaultColorButtonStyle(color: viewModel.chosenWeather.color, radius: 24))
            
            Button {
                
            } label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                    Text("Add")
                        .font(.custom("Montserrat-Bold", size: 16))
                        .foregroundColor(.white)
                }
                
            }
            .padding(.bottom, 24)
            .buttonStyle(DefaultColorButtonStyle(color: viewModel.chosenWeather.color, radius: 24))
            .disabled(true)
        }
        
    }
}


struct TouchGestureViewModifier: ViewModifier {
    let touchBegan: () -> Void
    let touchEnd: (Bool) -> Void

    @State private var hasBegun = false
    @State private var hasEnded = false

    private func isTooFar(_ translation: CGSize) -> Bool {
        let distance = sqrt(pow(translation.width, 2) + pow(translation.height, 2))
        return distance >= 20.0
    }

    func body(content: Content) -> some View {
        content.gesture(DragGesture(minimumDistance: 0)
                .onChanged { event in
                    guard !self.hasEnded else { return }

                    if self.hasBegun == false {
                        self.hasBegun = true
                        self.touchBegan()
                    } else if self.isTooFar(event.translation) {
                        self.hasEnded = true
                        self.touchEnd(false)
                    }
                }
                .onEnded { event in
                    if !self.hasEnded {
                        let success = !self.isTooFar(event.translation)
                        self.touchEnd(success)
                    }
                    self.hasBegun = false
                    self.hasEnded = false
                })
    }
}

extension View {
    func onTouchGesture(touchBegan: @escaping () -> Void,
                      touchEnd: @escaping (Bool) -> Void) -> some View {
        modifier(TouchGestureViewModifier(touchBegan: touchBegan, touchEnd: touchEnd))
    }
}
