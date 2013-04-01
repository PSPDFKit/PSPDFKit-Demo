//
//  PSPDFLinkAnnotationBaseView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotationViewProtocol.h"

@class PSPDFLinkAnnotation;

/// Base class for all link-annotation subclasses.
@interface PSPDFLinkAnnotationBaseView : UIView <PSPDFAnnotationViewProtocol>

/// All annotation views are initialized with a frame.
- (id)initWithFrame:(CGRect)frame;

/// Saves the attached link annotation.
@property (nonatomic, strong, readonly) PSPDFLinkAnnotation *linkAnnotation;

/// Defaults to a zIndex of 1.
@property (nonatomic, assign) NSUInteger zIndex;

@end
