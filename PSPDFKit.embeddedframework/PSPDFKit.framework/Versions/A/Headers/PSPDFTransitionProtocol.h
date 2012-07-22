//
//  PSPDFTransitionProtocol.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFPageView, PSPDFViewController, PSPDFPagedScrollView;

// Implement by custom UIViewController's to support custom transitions.
@protocol PSPDFTransitionProtocol <NSObject>

// Set page to new value. Optionally animates.
- (void)setPage:(NSUInteger)page animated:(BOOL)animated;

// Returns an array of NSNumber's for the current visible page numbers. (ordered)
- (NSArray *)visiblePageNumbers;

// Get pageView for a specific page. Returns nil if page isn't currently loaded.
- (PSPDFPageView *)pageViewForPage:(NSUInteger)page;

// Associated pdfController.
@property(nonatomic, unsafe_unretained) PSPDFViewController *pdfController;

// Associated scrollview. Might be nil if transition doesn't support zooming.
@property(nonatomic, ps_weak) PSPDFPagedScrollView *scrollView;

@optional

/// Return array of pageViews. (performance optimization)
- (NSArray *)visiblePageViews;

@end
