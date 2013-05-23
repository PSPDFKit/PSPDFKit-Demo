//
//  PSPDFViewState.h
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
#import "PSPDFModel.h"

// Similar to CGPointZero, but this shows that the point is not initialized, while (0,0) is valid.
extern const CGPoint PSPDFNilPoint;

/// Represents a certain view state (document position, zoom) of a PSPDFDocument.
@interface PSPDFViewState : PSPDFModel

/// Designated initializer.
- (id)initWithPage:(NSUInteger)page;

/// Zoom scale.
@property (nonatomic, assign) CGFloat zoomScale;

/// Content offset.
@property (nonatomic, assign) CGPoint contentOffset;

/// Visible Page.
@property (nonatomic, assign) NSUInteger page;

@end
