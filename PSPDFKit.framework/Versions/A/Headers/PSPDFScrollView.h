//
//  PSPDFScrollView.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFTilingView.h"
#import "PSPDFCache.h"

@class PSPDFDocument, PSPDFTilingView, PSPDFPage, PSPDFViewController;

@interface PSPDFScrollView : UIScrollView <UIScrollViewDelegate, PSPDFCacheDelegate> {
    PSPDFPage *leftPage_;
    PSPDFPage *rightPage_;
    
    PSPDFDocument *document_;
    PSPDFViewController *pdfController_;
    
    UIView *compoundPdfView_;
    UIView*compountPdfImageView_;
    
    NSUInteger page_;
    BOOL dualPageMode_;
    BOOL landscape_;
    BOOL doublePageModeOnFirstPage_;
    BOOL zoomingSmallDocumentsEnabled_;
    BOOL shadowEnabled_;
    
    NSInteger memoryWarningCounter_;
}

// display specific document with specified page
- (void)displayDocument:(PSPDFDocument *)aDocument withPage:(NSUInteger)pageId;

// releases document, removes all caches
- (void)releaseDocument;

// for memory warning relay
- (void)didReceiveMemoryWarning;

// weak reference to parent pdfController
@property (nonatomic, assign) PSPDFViewController *pdfController;

// current displayed page
@property (nonatomic, assign) NSUInteger page;

// if YES, two sites are displayed
@property (nonatomic, assign, getter=isDualPageMode) BOOL dualPageMode;

// shows first document page alone. Not relevant in PSPDFPageModeSinge.
@property(nonatomic, assign) BOOL doublePageModeOnFirstPage;

// manually set if landsacape is enabled - needed for animations
@property (nonatomic, assign, getter=isLandscape) BOOL landscape;

// allow zooming of small documents to screen width/height
@property(nonatomic, assign, getter=isZoomingSmallDocumentsEnabled) BOOL zoomingSmallDocumentsEnabled;

// enables/disables page shadow
@property(nonatomic, assign, getter=isShadowEnabled) BOOL shadowEnabled;

// for subclassing
- (CGPathRef)renderPaperCurl:(UIView*)imgView;
- (void)configureShadowForLayer:(CALayer *)layer;

@end
