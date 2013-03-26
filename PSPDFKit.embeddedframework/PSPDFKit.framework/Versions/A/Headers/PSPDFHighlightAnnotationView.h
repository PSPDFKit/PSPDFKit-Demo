//
//  PSPDFHighlightAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFLinkAnnotationBaseView.h"

/// Display a tappable highlight annotation.
@interface PSPDFHighlightAnnotationView : PSPDFLinkAnnotationBaseView

/// Embedded UIButton.
@property (nonatomic, strong, readonly) UIButton *button;

/// Called when button is pressed.
- (void)touchDown;

/// Called when button is released.
- (void)touchUp;

@end
