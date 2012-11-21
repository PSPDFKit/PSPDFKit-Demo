//
//  PSPDFWebViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//  Parts of this code is based on https://github.com/samvermette/SVWebViewController.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFBaseViewController.h"
#import "PSPDFStyleable.h"

@class PSPDFViewController;

@protocol PSPDFWebViewControllerDelegate <NSObject>

/// Controller where the webViewController has been pushed to (to dismiss modally)
- (UIViewController *)masterViewController;

@end 

/// Enable to completely match the toolbar style with the PSPDFViewController.
/// Defaults to NO because IMO it doesn't look that great.
extern BOOL PSPDFHonorBlackAndTranslucentSettingsOnWebViewController;

typedef NS_ENUM(NSUInteger, PSPDFWebViewControllerAvailableActions) {
    PSPDFWebViewControllerAvailableActionsNone             = 0,
    PSPDFWebViewControllerAvailableActionsOpenInSafari     = 1 << 0,
    PSPDFWebViewControllerAvailableActionsMailLink         = 1 << 1,
    PSPDFWebViewControllerAvailableActionsCopyLink         = 1 << 2,
    PSPDFWebViewControllerAvailableActionsPrint            = 1 << 3,
    PSPDFWebViewControllerAvailableActionsStopReload       = 1 << 4,
    PSPDFWebViewControllerAvailableActionsBack             = 1 << 5,
    PSPDFWebViewControllerAvailableActionsForward          = 1 << 6,
    PSPDFWebViewControllerAvailableActionsAll              = 0xFFFFFF
};

/// Inline Web Browser.
@interface PSPDFWebViewController : PSPDFBaseViewController <PSPDFStyleable, UIWebViewDelegate>

/// Use this to get a UINavigationController with a Done-Button.
/// Convenience-call. Not used within PSPDFKit.
+ (UINavigationController *)modalWebViewWithURL:(NSURL *)URL;

/// Creates a new PSPDFWebViewController with the specified URL.
- (id)initWithURL:(NSURL *)URL;

/// Controls the available actions under the more icon.
/// Defaults to all actions available in PSPDFWebViewControllerAvailableActions.
@property (nonatomic, assign) PSPDFWebViewControllerAvailableActions availableActions;

/// Internal webview used.
@property (nonatomic, strong, readonly) UIWebView *webView;

/// Access popover controller, if attached.
@property (nonatomic, strong) UIPopoverController *popoverController;

/// Associated delegate, connects to the PSPDFViewController
@property (nonatomic, weak) id<PSPDFWebViewControllerDelegate> delegate;

/// Defaults to YES. Will be checked in the default implementation of setActivityIndicatorEnabled.
/// Set to NO to NOT change the global network activity indicator.
@property (nonatomic, assign) BOOL updateGlobalActivityIndicator;

@end

@interface PSPDFWebViewController (SubclassingHooks)

/// Override if you have your own network activity manager.
/// Defaults to [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
- (void)setActivityIndicatorEnabled:(BOOL)enabled;

@end
