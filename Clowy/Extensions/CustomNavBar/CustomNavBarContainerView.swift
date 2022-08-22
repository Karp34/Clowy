////
////  CustomNavBArContainerVirew.swift
////  Clowy
////
////  Created by Егор Карпухин on 03.05.2022.
////
//
//import SwiftUI
//
//struct CustomNavBarContainerView<Content: View>: View {
//    let content: Content
//    @State private var showBackButton: Bool = true
//    @State private var title: String =  ""
//    @State private var subtitle: String? = nil
//    @State private var color: String =  "#F7F8FA"
//    @State private var textColor: String =  "#23232D"
//    @State private var rightButtonText: String? = nil
//    @State private var rightButtonImage: String? = nil
//    @State private var rightButtonTextColor: String? = nil
//    @State private var rightButtonColor: String? = nil
//    @State private var rightButtonPaddings: [CGFloat]? = nil
//    @State private var newRightButton: AnyView? = nil
//    
//
//    
//    init(@ViewBuilder content: () -> Content) {
//        self.content = content()
//    }
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            CustomNavBarView(showBackButton: showBackButton, title: title, subtitle: subtitle, color: color, textColor: textColor, rightButtonText: rightButtonText, rightButtonImage: rightButtonImage, rightButtomTextColor: rightButtonTextColor, rightButtomColor: rightButtonColor, rightButtomPaddings: rightButtonPaddings, newRightButton: newRightButton)
//            content
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//        .onPreferenceChange(CustomNavBarTitlePreferenceKey.self, perform: {value in
//            self.title = value})
//        .onPreferenceChange(CustomNavBarSubtitlePreferenceKey.self, perform: {value in
//            self.subtitle = value})
//        .onPreferenceChange(CustomNavBarBackButtonPreferenceKey.self, perform: {value in
//            self.showBackButton = !value})
//        .onPreferenceChange(CustomNavBarColorKey.self, perform: {value in
//            self.color = value})
//        .onPreferenceChange(CustomNavBarRightButtonTextKey.self, perform: {value in
//            self.rightButtonText = value})
//        .onPreferenceChange(CustomNavBarRightButtonImageKey.self, perform: {value in
//            self.rightButtonImage = value})
//        .onPreferenceChange(CustomNavBarRightButtonTextColorKey.self, perform: {value in
//            self.rightButtonTextColor = value})
//        .onPreferenceChange(CustomNavBarRightButtonColorKey.self, perform: {value in
//            self.rightButtonColor = value})
//        .onPreferenceChange(CustomNavBarRightButtonPaddings.self, perform: {value in
//            self.rightButtonPaddings = value})
////        .onPreferenceChange(CustomNavBarRightButtonPreferenceKey.self, perform: {value in
////            self.newRightButton = value})
//    }
//}
//
//struct CustomNavBarContainerVirew_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomNavBarContainerView {
//            ZStack{
//                if #available(iOS 14.0, *) {
//                    Color.green.ignoresSafeArea()
//                } else {
//                    Color.green
//                }
//                Text("Hello")
//                    .foregroundColor(.white)
//                    .customNavigationTitle("NEw Title")
//                    .customNavigationSubtitle("subtitle")
//                    .customNavigationBarBackButtonHidden(true)
//                    .customNavigationBarColor("#646C75")
//            }
//        }
//    }
//}
//
