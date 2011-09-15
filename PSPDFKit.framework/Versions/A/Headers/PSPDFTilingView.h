//
//  PSPDFTilingView.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <QuartzCore/CATiledLayer.h>

@class PSPDFDocument, PSPDFPage, PSPDFScrollView;

/// represents the CATiledLayer, the dynamic pdf renderer
@interface PSPDFTilingView : UIView {
    PSPDFDocument *document_;
    PSPDFPage     *pdfPage_;
    NSInteger      page_;
    CGRect         pageRenderRect_;
    UIImage       *pdfRenderImage_;
    BOOL           renderStepTwo_;
    NSTimer       *debugTimer_;
}

/// init the CATiledLayer
- (id)initWithFrame:(CGRect)frame;

/// explicitely destroy the layer. actual dealloc may happen in a block, so destroy explicitely.
- (void)stopTiledRenderingAndRemoveFromSuperlayer;

/// returns attached scrollview (if attached)
- (PSPDFScrollView *)scrollView;

/// document to display
@property(nonatomic, retain) PSPDFDocument *document;

/// current page to display
@property(nonatomic, assign) NSInteger page;

/// page that hosts the tiling view object
@property(nonatomic, assign) PSPDFPage *pdfPage;

/// currenct rect in which page is rendered
@property(nonatomic, assign, readonly) CGRect pageRenderRect;

@end

/// CATiledLayer-Subclass with disabled animations
@interface PSPDFTiledLayer : CATiledLayer
@end
