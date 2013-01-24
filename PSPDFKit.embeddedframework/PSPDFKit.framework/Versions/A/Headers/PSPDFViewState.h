//
//  PSPDFViewState.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFModel.h"

// Similar to CGPointZero, but this shows that the point is not initialized, while (0,0) is valid.
extern const CGPoint PSPDFNilPoint;

///
/// Represents a certain view state (document position, zoom) of a PSPDFDocument.
///
@interface PSPDFViewState : PSPDFModel

/// Designated initializer.
- (id)initWithPage:(NSUInteger)page;

/// Zoom scale.
@property (nonatomic, assign) CGFloat zoomScale;

/// Content offset.
@property (nonatomic, assign) CGPoint contentOffset;

/// Visible Page.
@property (nonatomic, assign) NSUInteger page;

/// Show the HUD.
@property (nonatomic, assign, getter=isHUDVisible) BOOL HUDVisible;

@end
