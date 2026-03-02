//
//  ShortsBlockerScript.swift
//  YouTube No Shorts
//
//  CSS and JavaScript to hide all Shorts UI on m.youtube.com
//

import Foundation

enum ShortsBlockerScript {
    
    /// Combined CSS and JavaScript to inject into m.youtube.com
    /// Hides: bottom Shorts tab, Shorts in feed, Shorts sections, channel Shorts tabs
    static var injectionScript: String {
        """
        (function() {
            'use strict';
            
            var style = document.createElement('style');
            style.textContent = `
                ytm-pivot-bar-item-renderer:nth-child(2),
                ytm-reel-shelf-renderer,
                ytm-reel-shelf-renderer.item,
                ytm-rich-section-renderer:has(.ShortsLockupViewModelHostEndpoint),
                ytm-rich-section-renderer:has(ytm-shorts-lockup-view-model),
                ytm-shorts-lockup-view-model,
                ytm-shorts-lockup-view-model.horizontal-card-list-shorts-lockup-card,
                yt-tab-shape[tab-title="Shorts"],
                ytm-shorts-lockup-view-model.shortsLockupViewModelHost,
                ytm-rich-grid-renderer.is-shorts-gallery {
                    display: none !important;
                }
            `;
            document.documentElement.appendChild(style);
            
            function removeShortsElements() {
                document.querySelectorAll('ytm-pivot-bar-item-renderer').forEach(function(el) {
                    if (el.innerText === 'Shorts') {
                        el.style.display = 'none';
                        el.remove();
                    }
                });
                document.querySelectorAll('ytm-item-section-renderer').forEach(function(el) {
                    if (el.innerText && el.innerText.match(/Shorts/)) {
                        el.style.display = 'none';
                        el.remove();
                    }
                });
            }
            
            removeShortsElements();
            
            var observer = new MutationObserver(function() {
                removeShortsElements();
            });
            
            function attachObserver() {
                removeShortsElements();
                var target = document.querySelector('ytm-pivot-bar-renderer') || document.body || document.documentElement;
                if (target && !target._shortsObserved) {
                    target._shortsObserved = true;
                    observer.observe(target, { childList: true, subtree: true });
                }
            }
            
            if (document.body) {
                attachObserver();
            } else {
                document.addEventListener('DOMContentLoaded', attachObserver);
            }
        })();
        """
    }
}
