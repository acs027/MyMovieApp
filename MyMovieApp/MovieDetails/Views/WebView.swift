//
//  WebView.swift
//  MyMovieApp
//
//  Created by ali cihan on 30.12.2024.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let webView: WKWebView
    
    init() {
        self.webView = WKWebView()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    func goBack() {
        webView.goBack()
    }
    
    func goForward() {
        webView.goForward()
    }
    
    func loadURL(urlString: String) {
        webView.load(URLRequest(url: URL(string: urlString)!))
        
    }
}

#Preview {
    WebView()
}
