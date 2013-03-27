//
//  PSPDFPageViewController.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFTransitionHelper.h"

/// Implements the PageCurl-style famously presented in iBooks.
/// @note Due to the nature of the animation, it doesn't look well with non-equal sized documents.
@interface PSPDFPageViewController : UIPageViewController <PSPDFTransitionProtocol, PSPDFTransitionHelperDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource>

/// Designated initializer.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// If set to YES, the background of the UIViewController is used. Else you may get some animation artifacts. Defaults to NO.
@property (nonatomic, assign) BOOL useSolidBackground;

/// Clips the page to its boundaries, not showing a pageCurl on empty background. Defaults to YES.
/// Usually you want this, unless your document is variable sized.
@property (nonatomic, assign) BOOL clipToPageBoundaries;

@end
