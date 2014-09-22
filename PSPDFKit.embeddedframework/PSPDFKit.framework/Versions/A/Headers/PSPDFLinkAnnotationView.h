//
//  PSPDFLinkAnnotationView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PSPDFAnnotationViewProtocol.h"
#import "PSPDFLinkAnnotationBaseView.h"

@class PSPDFLinkAnnotation;

/// Displays an annotation link.
@interface PSPDFLinkAnnotationView : PSPDFLinkAnnotationBaseView

/// Convenience setter for the borderColor. If you need more control use button.layer.*.
/// Defaults to `[UIColor colorWithRed:0.055f green:0.129f blue:0.800f alpha:0.1f]` (google-link-blue)
@property (nonatomic, strong) UIColor *borderColor UI_APPEARANCE_SELECTOR;

/// Roundness of the border. Defaults to 4.
@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

/// Stroke width. Defaults to 1.
@property (nonatomic, assign) CGFloat strokeWidth UI_APPEARANCE_SELECTOR;

/// Option to not mark small targets. (small = width/height < 6) Defaults to YES.
@property (nonatomic, assign, getter=shouldHideSmallLinks) BOOL hideSmallLinks;

/// Increases touch target by overspan pixel. Defaults to 15/15. Overspan is not visible.
@property (nonatomic, assign) CGSize overspan UI_APPEARANCE_SELECTOR;

@end
