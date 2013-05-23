//
//  PSPDFWebAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
