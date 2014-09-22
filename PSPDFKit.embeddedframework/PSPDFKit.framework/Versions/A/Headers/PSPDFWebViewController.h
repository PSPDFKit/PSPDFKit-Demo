//
//  PSPDFWebViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFBaseViewController.h"
#import "PSPDFStyleable.h"

@class PSPDFViewController, PSPDFAlertView;

/// Delegate for the `PSPDFWebViewController` to customize URL handling.
@protocol PSPDFWebViewControllerDelegate <NSObject>

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
    PSPDFWebViewControllerAvailableActionsFacebook         = 1 << 7,
    PSPDFWebViewControllerAvailableActionsTwitter          = 1 << 8,
    PSPDFWebViewControllerAvailableActionsMessage          = 1 << 9,
    PSPDFWebViewControllerAvailableActionsOpenInChrome     = 1 << 10, /// Only offered if Google Chrome is actually installed.
    PSPDFWebViewControllerAvailableActionsAll              = 0xFFFFFF
};

/// Inline Web Browser.
@interface PSPDFWebViewController : PSPDFBaseViewController <PSPDFStyleable, UIWebViewDelegate>

/// Use this to get a `UINavigationController` with a done-button.
+ (UINavigationController *)modalWebViewWithURL:(NSURL *)URL;

/// Creates a new `PSPDFWebViewController` with the specified custom URL request.
- (instancetype)initWithURLRequest:(NSURLRequest *)request;

/// Creates a new `PSPDFWebViewController` with the specified URL.
- (instancetype)initWithURL:(NSURL *)URL;

/// Controls the available actions under the more icon.
/// Defaults to `PSPDFWebViewControllerAvailableActionsAll&~PSPDFWebViewControllerAvailableActionsStopReload` on iPad and
/// `PSPDFWebViewControllerAvailableActionsAll` on iPhone (but with conditionally visible toolbars).
@property (nonatomic, assign) PSPDFWebViewControllerAvailableActions availableActions;

/// Access popover controller, if attached.
@property (nonatomic, strong) UIPopoverController *popoverController;

/// Associated delegate, connects to the `PSPDFViewController`.
@property (nonatomic, weak) IBOutlet id<PSPDFWebViewControllerDelegate> delegate;

/// Defaults to YES. Will be checked in the default implementation of `setActivityIndicatorEnabled`.
/// Set to NO to NOT change the global network activity indicator.
@property (nonatomic, assign) BOOL updateGlobalActivityIndicator;

/// If enabled, shows a progress indicator much like Safari on iOS 7. Defaults to YES.
/// Set this before the view is loaded.
@property (nonatomic, assign) BOOL showProgressIndicator;

/// If set to YES, a custom HTML is loaded when the `UIWebView` encounters an error (like 404).
/// Defaults to YES.
@property (nonatomic, assign) BOOL useCustomErrorPage;

/// If set to yes, we will evaluate `document.title` from the web content and update the title.
/// Defaults to YES.
@property (nonatomic, assign) BOOL shouldUpdateTitleFromWebContent;

/// Uses `WKWebView` when available. Needs to be set before the view is initialized. YES on iOS 8 and higher.
/// This can also be controlled via the global `PSPDFWebKitLegacyModeKey` setting.
@property (nonatomic, assign) BOOL useModernWebKit;

/// The excluded activities.
/// Defaults to `@[UIActivityTypePostToWeibo, UIActivityTypePostToTencentWeibo, UIActivityTypeSaveToCameraRoll]`.
@property (nonatomic, copy) NSArray *excludedActivities;

@end

@interface PSPDFWebViewController (SubclassingHooks)

/// Internal webview. Either `UIWebView` or `WKWebView`, depending if iOS 7 or iOS 8+.
@property (nonatomic, strong, readonly) UIView *webView;

/// Override if you have your own network activity manager.
/// Defaults to `[UIApplication.sharedApplication setNetworkActivityIndicatorVisible:YES]`;
- (void)setActivityIndicatorEnabled:(BOOL)enabled;

/// Called on error events if useCustomErrorPage is set.
/// Uses the `StandardError.html` inside `PSPDFKit.bundle`.
- (void)showHTMLWithError:(NSError *)error;

// This is your chance to modify the settings on the activity controller before it's displayed.
- (UIActivityViewController *)createDefaultActivityViewController;

// Toolbar action items. Subclass as needed.
- (void)goBack:(id)sender;
- (void)goForward:(id)sender;
- (void)reload:(id)sender;
- (void)stop:(id)sender;
- (void)action:(id)sender;
- (void)done:(id)sender;

@end
