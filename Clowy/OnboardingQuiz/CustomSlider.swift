//
//  CustomScrollView.swift
//  Clowy
//
//  Created by Егор Карпухин on 16.03.2024.
//

import SwiftUI
import AudioToolbox

struct CustomSliderView: View {
    @StateObject var viewModel = OnboardingQuizViewModel.shared
    @State var offset: CGFloat = 0
    let emojiList = GetEmojis.getEmojis()
    
    var body: some View {
        VStack(spacing: 8) {
            Image("trianglePointer")
                .resizable()
                .scaledToFill()
                .frame(width: 15, height: 10)
                .foregroundStyle(Color.primaryOrangeBrand)
            let pickerCount = emojiList.count
            let chosenEmojiId = Int(((offset)/100).rounded(.toNearestOrAwayFromZero))
            CustomSlider(pickerCount: pickerCount, offset: $offset) {
                HStack(spacing: 20) {
                    ForEach(emojiList, id: \.self) { emoji in
                        let isChosen = emoji.id == chosenEmojiId
                        ZStack {
                            Circle()
                                .foregroundStyle(Color(hex: emoji.color))
                                .opacity(isChosen ? 1 : 0.7)
                            Circle()
                                .stroke(Color.primaryOrangeBrand, style: StrokeStyle(lineWidth: 4))
                                .frame(width: 116)
                                .foregroundStyle(Color(hex: "#CEDAE1"))
                                .opacity(isChosen ? 1 : 0)
                            Image(emoji.icon)
                                .resizable()
                                .scaledToFill()
                                .frame(width: isChosen ? 96 : 64, height: isChosen ? 96 : 64)
                        }
                        .frame(width: isChosen ? 120 : 80, height: isChosen ? 120 : 80)
                        .animation(.easeInOut, value: isChosen)
                    }
                }
                .offset(x: (getRect().width-100)/2)
                .padding(.trailing, getRect().width-100)
                .frame(height: 120)
                .background(Color.primaryBackground)
                .onChange(of: chosenEmojiId) {
                    viewModel.user.userIcon = emojiList.first(where: { $0.id == chosenEmojiId})!.icon
                    print(viewModel.user)
                }
                .onAppear {
                    viewModel.user.userIcon = emojiList[0].icon
                }
            }
        }
    }
}

struct CustomSlider<Content: View>: UIViewRepresentable {
    
    var content: Content
    @Binding var offset: CGFloat
    var pickerCount: Int
    
    init(pickerCount: Int, offset: Binding<CGFloat>, @ViewBuilder content: @escaping ()->Content) {
        self.content = content()
        self._offset = offset
        self.pickerCount = pickerCount
    }
    
    func makeCoordinator() -> Coordinator {
        return CustomSlider.Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        
        scrollView.delegate = context.coordinator
        
        
        let swiftUIView = UIHostingController(rootView: content)
        context.coordinator.hostingController = swiftUIView
        let width = CGFloat(pickerCount * 100) + (getRect().width - 100)
        swiftUIView.view.frame = CGRect(x: 0, y: 0, width: width, height: 120)
        
        scrollView.addSubview(swiftUIView.view)
        
        scrollView.contentSize = swiftUIView.view.frame.size
        
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        
        return scrollView
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        context.coordinator.hostingController.rootView = content
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate{
        var parent: CustomSlider
        var hostingController: UIHostingController<Content>!
        
        init(parent: CustomSlider) {
            self.parent = parent
        }
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            parent.offset = scrollView.contentOffset.x
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let offset = scrollView.contentOffset.x
            let value = (offset / 100).rounded (.toNearestOrAwayFromZero)
            scrollView.setContentOffset(CGPoint(x: value * 100, y: 0), animated: true)
            
        }
        
        func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
            if !decelerate {
                let offset = scrollView.contentOffset.x
                let value = (offset / 100).rounded(.toNearestOrAwayFromZero)
                scrollView.setContentOffset(CGPoint(x: value * 100, y: 0), animated: true)
                
            }
        }
    }
}

func getRect()->CGRect{
    return UIScreen.main.bounds
}
