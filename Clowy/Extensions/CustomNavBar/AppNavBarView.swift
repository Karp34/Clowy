////
////  AppNAvBarView.swift
////  Clowy
////
////  Created by Егор Карпухин on 03.05.2022.
////
//
//import SwiftUI
//
//struct AppNavBarView: View {
//    var body: some View {
//        CustomNavView {
//            ZStack {
//                if #available(iOS 14.0, *) {
//                    Color.orange.ignoresSafeArea()
//                } else {
//                    Color.orange
//                }
//                
//                CustomNavLink {
//                    Text("Destination")
//                } label: {
//                    Text("Navigate")
//                }
//            }
//            .customNavBarItems(title: "NEW TITLE", subtitle: nil, backButtonHidden: false)
//            .customNavigationBarColor("#F7F8FA")
//            .customNavigationBarTextColor("#23232D")
//            .customNavBarRightButton(buttonImage: "plus", textColor: "#646C75", color: "#FFFFFF", paddings: [9,9])
//        }
//    }
//}
//
//struct AppNAvBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppNavBarView()
//    }
//}
//
//extension AppNavBarView {
//    private var defaultNavView: some View {
//        NavigationView {
//            if #available(iOS 14.0, *) {
//                ZStack {
//                    Color.green.ignoresSafeArea()
//                NavigationLink(
//                    destination: Text("Destination"),
//                    label: {Text("Navigate")})
//                }
//            .navigationTitle("Nav Title Here")
//            } else {
//                ZStack {
//                    Color.green
//                NavigationLink(
//                    destination: Text("Destination"),
//                    label: {Text("Navigate")})
//                }
//            }
//        }
//    }
//}
