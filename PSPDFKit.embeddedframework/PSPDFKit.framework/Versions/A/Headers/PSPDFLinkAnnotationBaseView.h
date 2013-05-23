//
//  PSPDFLinkAnnotationBaseView.h
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
