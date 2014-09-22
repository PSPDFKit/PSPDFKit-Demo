//
//  PSPDFSinglePageViewController.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFPresentationContext.h"

@class PSPDFViewController, PSPDFScrollView, PSPDFPageView, PSPDFSinglePageViewController;

/// Delegate protocol to show when the controller will be deallocated.
@protocol PSPDFSinglePageViewControllerDelegate <NSObject>

- (void)singlePageViewControllerReadyForReuse:(PSPDFSinglePageViewController *)singlePageViewController;
- (void)singlePageViewControllerWillDealloc:(PSPDFSinglePageViewController *)singlePageViewController;

@end

/// This wraps a `PSPDFPageView` into an `UIViewController`.
/// @note Used in `PSPDFPageViewController`.
@interface PSPDFSinglePageViewController : PSPDFBaseViewController

/// The configuration data source.
@property (nonatomic, weak) id <PSPDFPresentationContext> presentationContext;

/// current visible page.
@property (nonatomic, assign) NSUInteger page;

/// Delegate (usually connected to a `PSPDFPageViewController`)
@property (nonatomic, weak) IBOutlet id<PSPDFSinglePageViewControllerDelegate> delegate;

/// Clear internal state, prepare to be used again.
- (void)prepareForReuse;

/// If set to YES, the background of the `UIViewController` is used. Else you may get some animation artifacts. Defaults to NO.
@property (nonatomic, assign) BOOL useSolidBackground;

@end

@interface PSPDFSinglePageViewController (SubclassingHooks)

// Initially adds the view, later only re-calculates the frame
- (void)layoutPage;

/// internally used page view.
@property (nonatomic, strong, readonly) PSPDFPageView *pageView;

@end
