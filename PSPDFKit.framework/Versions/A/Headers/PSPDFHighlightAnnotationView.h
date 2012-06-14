//
//  PSPDFHighlightAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFLinkAnnotationBaseView.h"

/// Display a tappable highlight annotation.
@interface PSPDFHighlightAnnotationView : PSPDFLinkAnnotationBaseView

/// Embedded UIButton.
@property(nonatomic, strong, readonly) UIButton *button;

/// called when button is pressed.
- (void)touchDown;

/// called when button is released.
- (void)touchUp;

@end
