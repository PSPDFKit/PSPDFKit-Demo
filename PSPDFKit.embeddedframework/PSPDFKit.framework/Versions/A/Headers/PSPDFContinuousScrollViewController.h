//
//  PSPDFContinuousScrollViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFKitGlobal.h"
#import "PSPDFTransitionProtocol.h"
#import "PSPDFViewController.h"

@class PSPDFPageView, PSPDFPagingScrollView;

/// Controller for Safari-like continuous scrolling.
@interface PSPDFContinuousScrollViewController : PSPDFBaseViewController <PSPDFTransitionProtocol, UIScrollViewDelegate>

/// Designated initializer.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// Associated `PSPDFViewController`.
@property (nonatomic, weak) PSPDFViewController *pdfController;

/// Associated scroll view. Might be nil if transition doesn't support zooming.
@property (nonatomic, weak) PSPDFContentScrollView *scrollView;

/// Page padding width between single/double pages.
@property (nonatomic, assign) CGFloat pagePadding;

/// Customized content offset for `PSPDFViewState`.
@property(nonatomic, readonly) CGPoint compensatedContentOffset;

@end
