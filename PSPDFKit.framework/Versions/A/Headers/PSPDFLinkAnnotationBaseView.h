//
//  PSPDFLinkAnnotationBaseView.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSPDFAnnotationView.h"

@class PSPDFLinkAnnotation;

/// Base class for all link-annotation subclasses
@interface PSPDFLinkAnnotationBaseView : UIView <PSPDFAnnotationView>

@property(nonatomic, strong, readonly) PSPDFLinkAnnotation *linkAnnotation;

@end
