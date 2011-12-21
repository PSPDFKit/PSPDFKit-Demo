//
//  PSPDFWebAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFAnnotationView.h"

/// Encapsulates UIWebView with some additional features
@interface PSPDFWebAnnotationView : UIView <PSPDFAnnotationView, UIWebViewDelegate>

/// A boolean value that controls whether the web view draws shadows around the outside of its content.
@property(nonatomic, assign) BOOL shadowsHidden;

/// Internal webview used.
@property(nonatomic, strong, readonly) UIWebView *webView;

@end
