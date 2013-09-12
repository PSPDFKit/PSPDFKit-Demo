//
//  PSPDFSinglePageViewController.h
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
#import "PSPDFBaseViewController.h"

@class PSPDFViewController, PSPDFScrollView, PSPDFPageView, PSPDFSinglePageViewController;

/// Delegate protocol to show when the controller will be deallocated.
@protocol PSPDFSinglePageViewControllerDelegate <NSObject>

- (void)singlePageViewControllerReadyForReuse:(PSPDFSinglePageViewController *)singlePageViewController;
- (void)singlePageViewControllerWillDealloc:(PSPDFSinglePageViewController *)singlePageViewController;

@end

/// Displays a single pdf page. Only useful in conjunction with PSPDFPageViewController.
@interface PSPDFSinglePageViewController : PSPDFBaseViewController

/// create single page controller using the master pdf controller and a page. Does not has a scrollView in place.
- (id)initWithPDFController:(PSPDFViewController *)pdfController page:(NSUInteger)page;

/// Clear internal state, prepare to be used again.
- (void)prepareForReuse;

/// Attached pdfController.
@property (nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

/// internally used pageView.
@property (nonatomic, strong, readonly) PSPDFPageView *pageView;

/// current visible page.
@property (nonatomic, assign) NSUInteger page;

/// If set to YES, the background of the UIViewController is used. Else you may get some animation artifacts. Defaults to NO.
@property (nonatomic, assign) BOOL useSolidBackground;

/// Delegate (usually connected to a PSPDFPageViewController)
@property (nonatomic, assign) IBOutlet id<PSPDFSinglePageViewControllerDelegate> delegate;

@end

@interface PSPDFSinglePageViewController (SubclassingHooks)

// Initially adds the view, later only re-calculates the frame
- (void)layoutPage;

@end
