//
//  PSPDFLinkAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotationView.h"
#import "PSPDFKitGlobal.h"
#import "PSPDFLinkAnnotationBaseView.h"

@protocol PSPDFLinkAnnotationViewDelegate;
@class PSPDFLinkAnnotation;

/// Displays an annotation link.
@interface PSPDFLinkAnnotationView : PSPDFLinkAnnotationBaseView

/// Flash background, show that annotation was touched.
- (void)flashBackground;

/// Convenience setter for the borderColor. If you need more control use button.layer.*.
/// Defaults to [UIColor colorWithRed:0.055f green:0.129f blue:0.800f alpha:0.1f] (google-link-blue)
@property (nonatomic, strong) UIColor *borderColor;

/// Color that is displayed when a touch on the link is detected. Defaults to a dark gray.
@property (nonatomic, strong) UIColor *highlightBackgroundColor;

/// Roundness of the border. Defaults to 4.
@property (nonatomic, assign) CGFloat cornerRadius;

/// Stroke width. Defaults to 1.
@property (nonatomic, assign) CGFloat strokeWidth;

/// Color to fill when the button is pressed. Defaults to gray.
@property (nonatomic, strong) UIColor *pressedColor;

/// Option to not mark small targets. (small = width/height < 6) Defaults to YES.
@property (nonatomic, assign, getter=shouldHideSmallLinks) BOOL hideSmallLinks;

/// Increases touch target by overspan pixel. Defaults to 15/15. Overspan is not visible.
@property (nonatomic, assign) CGSize overspan;

/// Called when the annotation fires. Can be used for subclassing.
- (void)touchUp;

@end
