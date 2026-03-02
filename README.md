# YouTube No Shorts

An iPhone app that lets you use YouTube normally—log in, browse, search, watch—but **Shorts are completely hidden and inaccessible**.

- No Shorts tab in the bottom navigation
- No Shorts in your feed or subscriptions
- Blocked navigation to Shorts URLs (redirects to normal player when you tap a Short link)

## Requirements

- Xcode 16 or later
- iOS 18.0+
- iPhone or iPad

## Building

1. Open `YouTubeNoShortsApp.xcodeproj` in Xcode
2. Select your development team in **Signing & Capabilities**
3. Choose your device or simulator
4. Press **Run** (⌘R)

## How It Works

The app loads YouTube's mobile site (`m.youtube.com`) in a `WKWebView` and:

1. **Content injection**: Injects CSS and JavaScript to hide all Shorts UI elements (bottom tab, feed sections, channel tabs)
2. **URL interception**: Blocks navigation to `/shorts/` and `/feed/shorts`. When you tap a Short link, it redirects to the normal video player instead

Your login and cookies persist in the app, so you stay signed in.

## Personal Use

This app is intended for personal use. For App Store distribution, consider adding native features (pull-to-refresh, custom branding) to satisfy Apple's guidelines.
