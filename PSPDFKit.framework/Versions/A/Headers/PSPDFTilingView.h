//
//  PSPDFTilingView.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <QuartzCore/CATiledLayer.h>

@class PSPDFDocument, PSPDFPageView, PSPDFScrollView;

/// represents the CATiledLayer, the dynamic pdf renderer - allows sharp zooming.
@interface PSPDFTilingView : UIView 

/// init the CATiledLayer.
- (id)initWithFrame:(CGRect)frame;

/// explicitely destroy the layer. actual dealloc may happen in a block, so destroy explicitely.
- (void)stopTiledRenderingAndRemoveFromSuperlayer;

/// reset tiled layer, reloads pdf image.
- (void)resetLayer;

/// returns attached scrollview. (if attached)
- (PSPDFScrollView *)scrollView;

/// document to display.
@property(nonatomic, retain) PSPDFDocument *document;

/// current page to display.
@property(nonatomic, assign) NSInteger page;

/// page that hosts the tiling view object.
@property(nonatomic, assign) PSPDFPageView *pdfPage;

/// currenct rect in which page is rendered.
@property(nonatomic, assign, readonly) CGRect pageRenderRect;

@end

/// CATiledLayer-Subclass with disabled animations.
@interface PSPDFTiledLayer : CATiledLayer
@end
