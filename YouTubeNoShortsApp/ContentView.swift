//
//  ContentView.swift
//  YouTube No Shorts
//
//  Main view - full-screen YouTube WebView without Shorts
//

import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            YouTubeWebView(isLoading: $isLoading)
            
            if isLoading {
                ProgressView("Loading YouTube…")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.2)
            }
        }
    }
}

#Preview {
    ContentView()
}
