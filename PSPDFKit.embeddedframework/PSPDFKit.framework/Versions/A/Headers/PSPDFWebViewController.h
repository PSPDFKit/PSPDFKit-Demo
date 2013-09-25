//
//  PSPDFWebViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFBaseViewController.h"
#import "PSPDFStyleable.h"

@class PSPDFViewController, PSPDFAlertView;

/// Delegate for the PSPDFWebViewController to customize URL handling.
@protocol PSPDFWebViewControllerDelegate <NSObject>

/// Controller where the webViewController has been pushed to (to dismiss modally)
- (UIViewController *)masterViewController;

@optional

/// Callback to handle external URLs.
- (BOOL)handleExternalURL:(NSURL *)URL buttonCompletionBlock:(void (^)(PSPDFAlertView *alert, NSUInteger buttonIndex))completionBlock;

@end

typedef NS_ENUM(NSUInteger, PSPDFWebViewControllerAvailableActions) {
    PSPDFWebViewControllerAvailableActionsNone             = 0,
    PSPDFWebViewControllerAvailableActionsOpenInSafari     = 1 << 0,
    PSPDFWebViewControllerAvailableActionsMailLink         = 1 << 1,
    PSPDFWebViewControllerAvailableActionsCopyLink         = 1 << 2,
    PSPDFWebViewControllerAvailableActionsPrint            = 1 << 3,
    PSPDFWebViewControllerAvailableActionsStopReload       = 1 << 4,
    PSPDFWebViewControllerAvailableActionsBack             = 1 << 5,
    PSPDFWebViewControllerAvailableActionsForward          = 1 << 6,
    // Following actions can only be used on iOS6+ with UIActivityViewController.
    PSPDFWebViewControllerAvailableActionsFacebook         = 1 << 7,
    PSPDFWebViewControllerAvailableActionsTwitter          = 1 << 8,
    PSPDFWebViewControllerAvailableActionsMessage          = 1 << 9,
    PSPDFWebViewControllerAvailableActionsAll              = 0xFFFFFF
};

/// Inline Web Browser.
@interface PSPDFWebViewController : PSPDFBaseViewController <PSPDFStyleable, UIWebViewDelegate>

/// Use this to get a UINavigationController with a Done-Button.
/// Convenience-call. Not used within PSPDFKit.
+ (UINavigationController *)modalWebViewWithURL:(NSURL *)URL;

/// Creates a new PSPDFWebViewController with the specified URL.
- (id)initWithURL:(NSURL *)URL;

/// Creates a new PSPDFWebViewController with the specified custom URL request.
- (id)initWithURLRequest:(NSURLRequest *)urlRequest;

/// Controls the available actions under the more icon.
/// Defaults to all actions available in PSPDFWebViewControllerAvailableActions.
@property (nonatomic, assign) PSPDFWebViewControllerAvailableActions availableActions;

/// Internal webview.
@property (nonatomic, strong, readonly) UIWebView *webView;

/// Access popover controller, if attached.
@property (nonatomic, strong) UIPopoverController *popoverController;

/// Associated delegate, connects to the PSPDFViewController
@property (nonatomic, weak) IBOutlet id<PSPDFWebViewControllerDelegate> delegate;

/// Defaults to YES. Will be checked in the default implementation of setActivityIndicatorEnabled.
/// Set to NO to NOT change the global network activity indicator.
@property (nonatomic, assign) BOOL updateGlobalActivityIndicator;

/// If set to YES, a custom HTML is loaded when the UIWebView encounters an error (like 404).
/// Defaults to YES.
@property (nonatomic, assign) BOOL useCustomErrorPage;

/// Uses UIActivityViewController on iOS6 and later. Defaults to YES.
/// IF set to NO, the behavior on iOS5 and iOS6 will be the same, both use an UIActionSheet.
@property (nonatomic, assign) BOOL useActivitySheetIfAvailable;

@end

@interface PSPDFWebViewController (SubclassingHooks)

/// Override if you have your own network activity manager.
/// Defaults to [UIApplication.sharedApplication setNetworkActivityIndicatorVisible:YES];
- (void)setActivityIndicatorEnabled:(BOOL)enabled;

/// Called on error events if useCustomErrorPage is set.
/// Uses the "StandardError.html" inside PSPDFKit.bundle.
- (void)showHTMLWithError:(NSError *)error;

// This is your chance to modify the settings on the activity controller before it's displayed.
- (UIActivityViewController *)createDefaultActivityViewController;

// Toolbar items. Subclass as needed.
- (void)goBack:(id)sender;
- (void)goForward:(id)sender;
- (void)reload:(id)sender;
- (void)stop:(id)sender;
- (void)action:(id)sender;
- (void)doneButtonClicked:(id)sender;

@end
