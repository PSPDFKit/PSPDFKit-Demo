//
//  PSPDFScrollView.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFMAZeroingWeakRef.h"

@class PSPDFDocument, PSPDFTilingView, PSPDFPage, PSPDFViewController;

@interface PSPDFScrollView : UIScrollView <UIScrollViewDelegate> {
    PSPDFPage *leftPage_;
    PSPDFPage *rightPage_;
    
    PSPDFDocument *document_;
    PSPDFMAZeroingWeakRef *pdfControllerRef_;
    
    UIView *compoundView_;
    
    NSUInteger page_;
    BOOL dualPageMode_;
    BOOL doublePageModeOnFirstPage_;
    BOOL zoomingSmallDocumentsEnabled_;
    BOOL shadowEnabled_;
    BOOL scrollOnTapPageEndEnabled_;
    BOOL fitWidth_;
    
    NSInteger memoryWarningCounter_;
}

/// display specific document with specified page
- (void)displayDocument:(PSPDFDocument *)aDocument withPage:(NSUInteger)pageId;

/// prepares reuse of internal data
- (void)prepareForReuse;

/// releases document, removes all caches. Call before releasing. Can be called multiple times w/o error.
- (void)releaseDocument;

// for memory warning relay
- (void)didReceiveMemoryWarning;

/// weak reference to parent pdfController
@property(nonatomic, assign) PSPDFViewController *pdfController;

/// current displayed page
@property(nonatomic, assign) NSUInteger page;

// actual view that gets zoomed. attach your views here instead of the PSPDFScrollView to get them zoomed.
@property(nonatomic, retain, readonly) UIView *compoundView;

/// if YES, two sites are displayed
@property (nonatomic, assign, getter=isDualPageMode) BOOL dualPageMode;

/// shows first document page alone. Not relevant in PSPDFPageModeSinge.
@property(nonatomic, assign) BOOL doublePageModeOnFirstPage;

/// allow zooming of small documents to screen width/height
@property(nonatomic, assign, getter=isZoomingSmallDocumentsEnabled) BOOL zoomingSmallDocumentsEnabled;

/// if true, pages are fit to screen width, not to either height or width (which one is larger - usually height)
@property(nonatomic, assign, getter=isFittingWidth) BOOL fitWidth;

/// enables/disables page shadow
@property(nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

/// tap on begin/end of page scrolls to previous/next page.
@property(nonatomic, assign, getter=isScrollOnTapPageEndEnabled) BOOL scrollOnTapPageEndEnabled;

/// for subclassing
- (CGPathRef)renderPaperCurl:(UIView*)imgView;

@end
