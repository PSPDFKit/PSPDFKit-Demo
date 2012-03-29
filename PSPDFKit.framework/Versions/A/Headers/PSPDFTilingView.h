//
//  PSPDFTilingView.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/CATiledLayer.h>
#import "PSPDFKitGlobal.h"

@class PSPDFDocument, PSPDFPageView, PSPDFScrollView;

/// represents the CATiledLayer, the dynamic pdf renderer - allows sharp zooming.
@interface PSPDFTilingView : UIView 

/// init the CATiledLayer.
- (id)initWithFrame:(CGRect)frame;

/// explicitely destroy the layer. actual dealloc may happen in a block, so destroy explicitely.
- (void)stopTiledRenderingAndRemoveFromSuperlayer;

/// reset tiled layer, reloads pdf image.
- (void)resetLayer;

/// document to display.
@property(nonatomic, strong) PSPDFDocument *document;

/// current page to display.
@property(nonatomic, assign) NSInteger page;

/// page that hosts the tiling view object.
@property(nonatomic, ps_weak) PSPDFPageView *pageView;

/// Set with the zoomScale of the parent scrollView.
@property(nonatomic, assign) CGFloat zoomScale;

/// Set from controller parent;
@property(nonatomic, assign) BOOL fitWidth;

@end

/// CATiledLayer-Subclass with disabled animations.
@interface PSPDFTiledLayer : CATiledLayer
@end
