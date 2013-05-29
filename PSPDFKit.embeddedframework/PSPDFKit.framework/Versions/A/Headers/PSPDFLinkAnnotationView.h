//
//  PSPDFLinkAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFAnnotationViewProtocol.h"
#import "PSPDFKitGlobal.h"
#import "PSPDFLinkAnnotationBaseView.h"

@class PSPDFLinkAnnotation;

/// Displays an annotation link.
@interface PSPDFLinkAnnotationView : PSPDFLinkAnnotationBaseView

/// Allows you to globally change the default link annotation border color.
/// Defaults to the default borderColor set in the class (blue).
/// @note Like all UI-related classes, you need to call this from the main thread.
+ (void)setGlobalBorderColor:(UIColor *)color;
+ (UIColor *)getGlobalBorderColor;

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
