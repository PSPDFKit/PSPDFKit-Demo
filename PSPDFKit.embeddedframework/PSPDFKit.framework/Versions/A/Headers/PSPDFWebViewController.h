//
//  PSPDFWebViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//  Parts of this code is based on https://github.com/samvermette/SVWebViewController.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFViewController.h"
#import "PSPDFBaseViewController.h"

/// Enable to completely match the toolbar style with the PSPDFViewController.
/// Defaults to NO because IMO it doesn't look that great.
extern BOOL PSPDFHonorBlackAndTranslucentSettingsOnViewController;

typedef NS_ENUM(NSUInteger, PSPDFWebViewControllerAvailableActions) {
    PSPDFWebViewControllerAvailableActionsNone             = 0,
    PSPDFWebViewControllerAvailableActionsOpenInSafari     = 1 << 0,
    PSPDFWebViewControllerAvailableActionsMailLink         = 1 << 1,
    PSPDFWebViewControllerAvailableActionsCopyLink         = 1 << 2,
    PSPDFWebViewControllerAvailableActionsPrint            = 1 << 3
};

/// Inline Web Browser.
@interface PSPDFWebViewController : PSPDFBaseViewController <UIWebViewDelegate>

/// Use this to get a UINavigationController with a Done-Button.
+ (UINavigationController *)modalWebViewWithURL:(NSURL *)URL;

/// Creates a new PSPDFWebViewController with the specified URL.
- (id)initWithURL:(NSURL *)URL;

/// Controls the available actions under the more icon.
/// Defaults to all actions available in PSPDFWebViewControllerAvailableActions.
@property(nonatomic, assign) PSPDFWebViewControllerAvailableActions availableActions;

/// Internal webview used.
@property(nonatomic, strong, readonly) UIWebView *webView;

/// Access popover controller, if attached.
@property(nonatomic, strong) UIPopoverController *popoverController;

// Customize the icon toolbar. Call before displaying.
- (void)copyStyleFromPDFViewController:(PSPDFViewController *)pdfController;
@property(nonatomic, assign) UIBarStyle barStyle;
@property(nonatomic, assign) BOOL isBarTranslucent;
@property(nonatomic, strong) UIColor *tintColor;

@end
