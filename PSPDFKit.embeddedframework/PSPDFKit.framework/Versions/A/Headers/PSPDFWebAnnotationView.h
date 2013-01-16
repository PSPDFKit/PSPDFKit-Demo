//
//  PSPDFWebAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFLinkAnnotationBaseView.h"

/// Encapsulates UIWebView with some additional features
@interface PSPDFWebAnnotationView : PSPDFLinkAnnotationBaseView <UIWebViewDelegate>

/// A boolean value that controls whether the web view draws shadows around the outside of its content.
@property (nonatomic, assign) BOOL shadowsHidden;

/// Internal webview used.
@property (nonatomic, strong, readonly) UIWebView *webView;

@end
