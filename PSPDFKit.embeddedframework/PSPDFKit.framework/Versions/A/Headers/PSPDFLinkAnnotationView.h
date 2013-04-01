//
//  PSPDFLinkAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotationViewProtocol.h"
#import "PSPDFKitGlobal.h"
#import "PSPDFLinkAnnotationBaseView.h"

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

/// Option to not mark small targets. (small = width/height < 6) Defaults to YES.
@property (nonatomic, assign, getter=shouldHideSmallLinks) BOOL hideSmallLinks;

/// Increases touch target by overspan pixel. Defaults to 15/15. Overspan is not visible.
@property (nonatomic, assign) CGSize overspan;

/// For performance reasons, rounded corners are disabled if too many link views are on a page.
/// Defaults to YES.
@property (nonatomic, assign) BOOL allowToDisableRoundedCorners;

/// If set to YES, will save the last rounded corner setting, and restore if set to no.
/// Defaults to NO.
@property (nonatomic, assign) BOOL disableRoundedCorners;

@end


@interface PSPDFLinkAnnotationView (SubclassingHooks)

/// Called when the annotation was flashed explicitely via `flashBackground`.
- (void)touchUp;

@end
