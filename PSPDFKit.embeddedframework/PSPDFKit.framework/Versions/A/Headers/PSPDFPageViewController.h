//
//  PSPDFPageViewController.h
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
#import "PSPDFTransitionProtocol.h"

/// Implements the PageCurl-style famously presented in iBooks.
/// @note Due to the nature of the animation, it doesn't look well with non-equal sized documents.
@interface PSPDFPageViewController : UIPageViewController <PSPDFTransitionProtocol, UIPageViewControllerDelegate, UIPageViewControllerDataSource>

/// Designated initializer.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// If set to YES, the background of the UIViewController is used. Else you may get some animation artifacts. Defaults to NO.
@property (nonatomic, assign) BOOL useSolidBackground;

/// Clips the page to its boundaries, not showing a pageCurl on empty background. Defaults to YES.
/// Usually you want this, unless your document is variable sized.
@property (nonatomic, assign) BOOL clipToPageBoundaries;

@end
