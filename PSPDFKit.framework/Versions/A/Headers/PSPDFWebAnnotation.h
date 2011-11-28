//
//  PSPDFWebAnnotation.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

/// Encapsulates UIWebView with some additional features
@interface PSPDFWebAnnotation : UIView <UIWebViewDelegate>

/// A boolean value that controls whether the web view draws shadows around the outside of its content.
@property(nonatomic, assign) BOOL shadowsHidden;

/// Internal webview used.
@property(nonatomic, retain, readonly) UIWebView *webView;

@end
