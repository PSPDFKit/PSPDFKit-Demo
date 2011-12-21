//
//  PSPDFHighlightAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFAnnotationView.h"

/// Display a tappable highlight annotation.
@interface PSPDFHighlightAnnotationView : UIView <PSPDFAnnotationView>

/// Embedded UIButton.
@property(nonatomic, strong, readonly) UIButton *button;

/// called when button is pressed.
- (void)touchDown;

/// called when button is released.
- (void)touchUp;

@end
