//
//  PSPDFTilingView.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/20/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <QuartzCore/CATiledLayer.h>

@class PSPDFDocument;

// represents the CATiledLayer, the dynamic pdf renderer
@interface PSPDFTilingView : UIView {
    UIImage       *pdfImage_;
    PSPDFDocument *document_;
    BOOL           backgroundImageCached_;  
    BOOL           tiledRenderingAllowed_;
    CGFloat        myScale;
    NSUInteger     page_;
}

// init the CATiledLayer
- (id)initWithFrame:(CGRect)frame andScale:(CGFloat)scale;

// explicitely destroy the layer. actual dealloc may happen in a block, so destroy explicitely.
- (void)stopTiledRenderingAndRemoveFromSuperlayer;

// document to display
@property(nonatomic, retain) PSPDFDocument *document;

// current page to display
@property(nonatomic, assign) NSUInteger page;

@end

@interface PSPDFTiledLayer : CATiledLayer
@end