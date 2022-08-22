////
////  CustomNavBarPreferenceKeys.swift
////  Clowy
////
////  Created by Егор Карпухин on 03.05.2022.
////
//
//import Foundation
//import SwiftUI
//
////@State private var showBackButton: Bool = true
////@State private var title: String =  "Title" // ""
////@State private var subtitle: String? = "Subtitle"// nil
//
//struct CustomNavBarTitlePreferenceKey: PreferenceKey {
//
//    static var defaultValue: String = ""
//    static func reduce(value: inout String, nextValue: () -> String) {
//        value = nextValue()
//    }
//}
//
//struct CustomNavBarSubtitlePreferenceKey: PreferenceKey {
//
//    static var defaultValue: String? = nil
//    static func reduce(value: inout String?, nextValue: () -> String?) {
//        value = nextValue()
//    }
//}
//
//struct CustomNavBarBackButtonPreferenceKey: PreferenceKey {
//
//    static var defaultValue: Bool = true
//    static func reduce(value: inout Bool, nextValue: () -> Bool) {
//        value = nextValue()
//    }
//}
//
//struct CustomNavBarColorKey: PreferenceKey {
//
//    static var defaultValue: String = "#646C75"
//    static func reduce(value: inout String, nextValue: () -> String) {
//        value = nextValue()
//    }
//}
//
//struct CustomNavBarTextColorKey: PreferenceKey {
//
//    static var defaultValue: String = "#23232D"
//    static func reduce(value: inout String, nextValue: () -> String) {
//        value = nextValue()
//    }
//}
//
//struct CustomNavBarRightButtonTextKey: PreferenceKey {
//
//    static var defaultValue: String? = nil
//    static func reduce(value: inout String?, nextValue: () -> String?) {
//        value = nextValue()
//    }
//}
//
//struct CustomNavBarRightButtonImageKey: PreferenceKey {
//
//    static var defaultValue: String? = nil
//    static func reduce(value: inout String?, nextValue: () -> String?) {
//        value = nextValue()
//    }
//}
//
//struct CustomNavBarRightButtonTextColorKey: PreferenceKey {
//
//    static var defaultValue: String? = nil
//    static func reduce(value: inout String?, nextValue: () -> String?) {
//        value = nextValue()
//    }
//}
//
//struct CustomNavBarRightButtonColorKey: PreferenceKey {
//
//    static var defaultValue: String? = nil
//    static func reduce(value: inout String?, nextValue: () -> String?) {
//        value = nextValue()
//    }
//}
//
//struct CustomNavBarRightButtonPaddings: PreferenceKey {
//
//    static var defaultValue: [CGFloat]? = nil
//    static func reduce(value: inout [CGFloat]?, nextValue: () -> [CGFloat]?) {
//        value = nextValue()
//    }
//}
//
//struct CustomNavBarRightButtonPreferenceKey: PreferenceKey, Equatable{
//
//    static var defaultValue: AnyView? = nil
//    static func reduce(value: inout AnyView?, nextValue: () -> AnyView?) {
//        value = nextValue()
//    }
//}
//
//extension View {
//    func customNavigationTitle(_ title: String) -> some View {
//        preference(key: CustomNavBarTitlePreferenceKey.self, value: title)
//    }
//
//    func customNavigationSubtitle(_ subtitle: String?) -> some View {
//        preference(key: CustomNavBarSubtitlePreferenceKey.self, value: subtitle)
//    }
//
//    func customNavigationBarBackButtonHidden(_ hidden: Bool) -> some View {
//        preference(key: CustomNavBarBackButtonPreferenceKey.self, value: hidden)
//    }
//
//    func customNavigationBarColor(_ color: String) -> some View {
//        preference(key: CustomNavBarColorKey.self, value: color)
//    }
//
//    func customNavigationBarTextColor(_ color: String) -> some View {
//        preference(key: CustomNavBarTextColorKey.self, value: color)
//    }
//
//    func customNavigationBarRightButtonText(_ buttonText: String?) -> some View {
//        preference(key: CustomNavBarRightButtonTextKey.self, value: buttonText)
//    }
//
//    func customNavigationBarRightButtonImage(_ buttonImage: String?) -> some View {
//        preference(key: CustomNavBarRightButtonImageKey.self, value: buttonImage)
//    }
//
//    func customNavigationBarRightButtonTextColor(_ buttonTextColor: String?) -> some View {
//        preference(key: CustomNavBarRightButtonTextColorKey.self, value: buttonTextColor)
//    }
//
//    func customNavigationBarRightButtonColor(_ buttonColor: String?) -> some View {
//        preference(key: CustomNavBarRightButtonColorKey.self, value: buttonColor)
//    }
//
//    func customNavigationBarRightButtonPaddings(_ padding: [CGFloat]?) -> some View {
//        preference(key: CustomNavBarRightButtonPaddings.self, value: padding)
//    }
//
//    func customNavigationBarRightButton(_ view: AnyView?) -> some View {
//        preference(key: CustomNavBarRightButtonPreferenceKey.self, value: view)
//    }
//
//    func customNavBarItems(title: String = "", subtitle: String? = nil, backButtonHidden: Bool = false) -> some View {
//        self
//            .customNavigationTitle(title)
//            .customNavigationSubtitle(subtitle)
//            .customNavigationBarBackButtonHidden(backButtonHidden)
//    }
//
//    func customNavBarRightButton(text: String? = nil, buttonImage: String? = nil, textColor: String? = nil, color: String? = nil, paddings: [CGFloat]? = nil) -> some View {
//        self
//            .customNavigationBarRightButtonText(text)
//            .customNavigationBarRightButtonImage(buttonImage)
//            .customNavigationBarRightButtonTextColor(textColor)
//            .customNavigationBarRightButtonColor(color)
//            .customNavigationBarRightButtonPaddings(paddings)
//
//    }
//}
