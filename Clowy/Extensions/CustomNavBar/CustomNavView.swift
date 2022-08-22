////
////  CustomNavView.swift
////  Clowy
////
////  Created by Егор Карпухин on 03.05.2022.
////
//
//import SwiftUI
//
//struct CustomNavView<Content: View>: View {
//    let content: Content
//    init (@ViewBuilder content: () -> Content) {
//        self.content = content()
//    }
//    var body: some View {
//        NavigationView {
//            CustomNavBarContainerView {
//                content
//            }
//            .navigationBarHidden(true)
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
////
////struct CustomNavView_Previews: PreviewProvider {
////    static var previews: some View {
////        CustomNavView {
////            if #available(iOS 14.0, *) {
////                Color.red.ignoresSafeArea()
////            } else {
////                Color.red
////            }
////        }
////    }
////}
