//
//  PSPDFTransitionProtocol.h
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

@class PSPDFPageView, PSPDFViewController, PSPDFContentScrollView;

// Implement by custom UIViewController's to support custom transitions.
@protocol PSPDFTransitionProtocol <NSObject>

// Set page to new value. Optionally animates.
- (void)setPage:(NSUInteger)page animated:(BOOL)animated;

// Returns an array of NSNumber's for the current visible page numbers. (ordered)
- (NSArray *)visiblePageNumbers;

// Get pageView for a specific page. Returns nil if page isn't currently loaded.
- (PSPDFPageView *)pageViewForPage:(NSUInteger)page;

// Associated pdfController. (unsafe_unretained because we observe KVO on this)
@property (nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

// Associated scroll view. Might be nil if transition doesn't support zooming.
@property (nonatomic, weak) PSPDFContentScrollView *scrollView;

@optional

/// Return array of pageViews. (performance optimization)
- (NSArray *)visiblePageViews;

/// Customized content offset for PSPDFViewState.
- (CGPoint)compensatedContentOffset;

@end
