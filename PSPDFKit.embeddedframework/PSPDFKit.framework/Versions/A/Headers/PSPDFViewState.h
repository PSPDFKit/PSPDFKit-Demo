//
//  PSPDFViewState.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/// Represents a certain view state (document position, zoom) of a PSPDFDocument.
@interface PSPDFViewState : NSObject <NSCoding, NSCopying>

/// Zoom scale.
@property(nonatomic, assign) CGFloat zoomScale;

/// Content offset.
@property(nonatomic, assign) CGPoint contentOffset;

/// Visible Page.
@property(nonatomic, assign) NSUInteger page;

/// Show the HUD.
@property(nonatomic, assign, getter=isHUDVisible) BOOL HUDVisible;

@end
