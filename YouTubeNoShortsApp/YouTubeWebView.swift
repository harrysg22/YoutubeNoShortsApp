//
//  YouTubeWebView.swift
//  YouTube No Shorts
//
//  WKWebView wrapper that loads m.youtube.com with Shorts blocker injection
//

import SwiftUI
import WebKit

struct YouTubeWebView: UIViewRepresentable {
    
    @Binding var isLoading: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.processPool = WKProcessPool()
        config.websiteDataStore = .default()
        config.preferences.javaScriptEnabled = true
        
        let contentController = WKUserContentController()
        let script = WKUserScript(
            source: ShortsBlockerScript.injectionScript,
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        contentController.addUserScript(script)
        config.userContentController = contentController
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.bounces = true
        webView.isOpaque = true
        webView.backgroundColor = .black
        
        webView.load(URLRequest(url: URL(string: "https://m.youtube.com")!))
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {}
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: YouTubeWebView
        private let shortsDelegate = YouTubeNavigationDelegate()
        
        init(_ parent: YouTubeWebView) {
            self.parent = parent
        }
        
        func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            shortsDelegate.webView(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}
