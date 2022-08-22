////
////  CustomNavLink.swift
////  Clowy
////
////  Created by Егор Карпухин on 03.05.2022.
////
//
//import SwiftUI
//
//struct CustomNavLink<Label: View, Destination: View>: View {
//    
//    let label: Label
//    let destination: Destination
//    
//    init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
//        self.destination = destination()
//        self.label = label()
//    }
//    
//    var body: some View {
//        NavigationLink {
//            CustomNavBarContainerView{
//                destination
//            }
//            .navigationBarHidden(true)
//        } label: {
//            label
//        }
//
//    }
//}
//
//struct CustomNavLink_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomNavView {
//            CustomNavLink {
//                Text("Desination")
//            } label: {
//                Text("Navigate")
//            }
//        }
//    }
//}
//
//extension UINavigationController {
//    open override func viewDidLoad() {
//        super.viewDidLoad()
//        interactivePopGestureRecognizer?.delegate = nil
//    }
//}
