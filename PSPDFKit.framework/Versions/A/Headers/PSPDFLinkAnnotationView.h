//
//  PSPDFLinkAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFAnnotationView.h"

/// Displays an annotation link.
@interface PSPDFLinkAnnotationView : UIButton <PSPDFAnnotationView>

/// Convenience setter for the borderColor. If you need more control use button.layer.*.
/// Defaults to [UIColor colorWithRed:1.f green:1.f blue:0.f alpha:0.5f] (yellow).
@property(nonatomic, strong) UIColor *borderColor;

/// Roundness of the border. Defaults to 5.
@property(nonatomic, assign) CGFloat cornerRadius;

/// Stroke width. Defaults to 1.
@property(nonatomic, assign) CGFloat strokeWidth;

/// Color to fill when the button is pressed. Defaults to gray.
@property(nonatomic, strong) UIColor *pressedColor;

/// Embedded UIButton.
@property(nonatomic, strong, readonly) UIButton *button;

/// Option to not mark small targets. (small = width/height < 6) Defaults to YES.
@property(nonatomic, assign, getter=shouldHideSmallLinks) BOOL hideSmallLinks;

/// Increases touch target by overspan pixel. Defaults to 5/5.
@property(nonatomic, assign) CGSize overspan;

/// called when button is pressed.
- (void)touchDown;

/// called when button is released.
- (void)touchUp;

@end
