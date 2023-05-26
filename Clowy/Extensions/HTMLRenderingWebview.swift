//
//  HTMLRenderingWebview.swift
//  Clowy
//
//  Created by Егор Карпухин on 13.02.2023.
//

import SwiftUI
import WebKit

struct HTMLRenderingWebView: UIViewRepresentable {
    @Binding var htmlString: String
    @Binding var baseURL: URL?

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if self.htmlString != context.coordinator.lastLoadedHTML {
            print("Updating HTML")
            context.coordinator.lastLoadedHTML = self.htmlString
            uiView.loadHTMLString(self.htmlString, baseURL: self.baseURL)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject {
        var parent: HTMLRenderingWebView
        var lastLoadedHTML = ""

        init(_ parent: HTMLRenderingWebView) {
            self.parent = parent
        }
    }
}
