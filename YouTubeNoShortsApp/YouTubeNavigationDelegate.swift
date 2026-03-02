//
//  YouTubeNavigationDelegate.swift
//  YouTube No Shorts
//
//  Intercepts navigation to block Shorts URLs
//

import WebKit

final class YouTubeNavigationDelegate: NSObject, WKNavigationDelegate {
    
    /// When true, redirects /shorts/VIDEO_ID to /watch?v=VIDEO_ID so the video plays in normal player
    var redirectShortsToNormalPlayer: Bool = true
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        let path = url.path
        let isShortsFeed = path.contains("/feed/shorts")
        let isShortsVideo = path.contains("/shorts/")
        
        if isShortsFeed {
            decisionHandler(.cancel)
            return
        }
        
        if isShortsVideo && redirectShortsToNormalPlayer {
            if let videoId = extractVideoIdFromShortsPath(path) {
                let watchURL = URL(string: "https://m.youtube.com/watch?v=\(videoId)")
                if let watchURL = watchURL {
                    webView.load(URLRequest(url: watchURL))
                    decisionHandler(.cancel)
                    return
                }
            }
        }
        
        if isShortsVideo && !redirectShortsToNormalPlayer {
            decisionHandler(.cancel)
            return
        }
        
        decisionHandler(.allow)
    }
    
    private func extractVideoIdFromShortsPath(_ path: String) -> String? {
        let shortsPrefix = "/shorts/"
        guard path.contains(shortsPrefix),
              let range = path.range(of: shortsPrefix) else {
            return nil
        }
        let afterPrefix = path[range.upperBound...]
        let videoId = String(afterPrefix).components(separatedBy: "/").first ?? String(afterPrefix)
        return videoId.isEmpty ? nil : videoId
    }
}
