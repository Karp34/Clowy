////
////  CustomNavBarView.swift
////  Clowy
////
////  Created by Егор Карпухин on 03.05.2022.
////
//
//import SwiftUI
//
//struct CustomNavBarView: View {
//    
//    @Environment(\.presentationMode) var presentationMode
//    let showBackButton: Bool
//    let title: String
//    let subtitle: String?
//    let color: String
//    let textColor: String
//    let rightButtonText: String?
//    let rightButtonImage: String?
//    let rightButtomTextColor: String?
//    let rightButtomColor: String?
//    let rightButtomPaddings: [CGFloat]?
//    let newRightButton: AnyView?
//    
//    
//    
//    var body: some View {
//        if #available(iOS 14.0, *) {
//            HStack {
//                if showBackButton {
//                    HStack{
//                        backButton
//                        Spacer()
//                    }
//                    .frame(width: 80)
//                }
//                Spacer()
//                titleSection
//                Spacer()
//                if rightButtonText != nil || rightButtonImage != nil{
//                    HStack{
//                        Spacer()
//                        rightButton
//                    }
//                    .frame(width: 80)
//                }
//            }
//            .padding(.leading, 25)
//            .padding(.bottom, 16)
//            .padding(.trailing, 16)
//            .accentColor(Color(hex: textColor))
//            .foregroundColor(Color(hex: textColor))
//            .font(.custom("Montserrat-Bold", size: 14))
//            .background(Color(hex: color).ignoresSafeArea(edges: .top))
//        } else {
//            HStack {
//                if showBackButton {
//                    HStack{
//                        backButton
//                        Spacer()
//                    }
//                    .frame(width: 80)
//                }
//                Spacer()
//                titleSection
//                Spacer()
//                if rightButtonText != nil || rightButtonImage != nil{
//                    HStack{
//                        Spacer()
//                        rightButton
//                    }
//                    .frame(width: 80)
//                }
//            }
//            .padding([.leading, .bottom, .trailing])
//            .accentColor(Color(hex: textColor))
//            .foregroundColor(Color(hex: textColor))
//            .font(.custom("Montserrat-Bold", size: 14))
//            .background(Color(hex: color))
//        }
//    }
//}
//
////struct CustomNavBarView_Previews: PreviewProvider {
////    static var previews: some View {
////        VStack {
////            CustomNavBarView(showBackButton: true, title: "Title", subtitle: "subtitle", color: "#CCCCCC", textColor: "#23232D", rightButtonText: "+", rightButtonImage: nil, rightButtomTextColor: "#646C75", rightButtomColor: "#FFFFFF", rightButtomPaddings: [9, 9])
////            Spacer()
////        }
////    }
////}
//
//extension CustomNavBarView {
//    private var backButton: some View {
//        Button  {
//            presentationMode.wrappedValue.dismiss()
//        } label: {
//            Image(systemName: "chevron.left")
//        }
//    }
//    
//    private var titleSection: some View {
//        VStack (spacing: 4) {
//            Text(title)
//                .font(.custom("Montserrat-Bold", size: 14))
//            if let subtitle = subtitle {
//                Text(subtitle)
//            }
//        }
//    }
//    
//    private var rightButton: some View {
//        Button  {
//            presentationMode.wrappedValue.dismiss()
//        } label: {
//            if let rightButtonText = rightButtonText {
//                Text(rightButtonText)
//                    .padding(.horizontal, rightButtomPaddings![0])
//                    .padding(.vertical, rightButtomPaddings![1])
//                    .font(.custom("Montserrat-Bold", size: 14))
//                    .foregroundColor(Color(hex: rightButtomTextColor!))
//                    .background(Color(hex: rightButtomColor!))
//                    .clipShape(RoundedRectangle(cornerRadius: 8))
//                    .shadow(color:Color(hex: "#646C75").opacity(0.1), radius: 30, y: 4)
//            } else if let rightButtonImage = rightButtonImage {
//                Image(rightButtonImage)
//                    .padding(.horizontal, rightButtomPaddings![0])
//                    .padding(.vertical, rightButtomPaddings![1])
//                    .foregroundColor(Color(hex: rightButtomTextColor!))
//                    .background(Color(hex: rightButtomColor!))
//                    .clipShape(RoundedRectangle(cornerRadius: 8))
//                    .shadow(color:Color(hex: "#646C75").opacity(0.1), radius: 30, y: 4)
//            }
//            else if let newRightButton = newRightButton{
//                newRightButton
//            } else {
//                Text("")
//                    .opacity(0)
//            }
//        }
//    }
//}
