//
//  PSPDFLinkAnnotationBaseView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFAnnotationViewProtocol.h"
#import "PSPDFModernizer.h"

@class PSPDFLinkAnnotation;

/// Base class for all link-annotation subclasses.
@interface PSPDFLinkAnnotationBaseView : UIView <PSPDFAnnotationViewProtocol>

/// All annotation views are initialized with a frame.
- (instancetype)initWithFrame:(CGRect)frame NS_DESIGNATED_INITIALIZER;

/// Saves the attached link annotation.
@property (nonatomic, strong, readonly) PSPDFLinkAnnotation *linkAnnotation;

/// Defaults to a zIndex of 1.
@property (nonatomic, assign) NSUInteger zIndex;

/// Internal content view. Subclasses should add content to that view.
@property (nonatomic, strong, readonly) UIView *contentView;

@end

@interface PSPDFLinkAnnotationBaseView (SubclassingHooks)

// Called when the annotation changes.
- (void)prepareForReuse NS_REQUIRES_SUPER;

// Called each time the annotation changes or if the content view is about to be displayed.
- (void)populateContentView;

// Will show/hide the content view.
- (void)setContentViewVisible:(BOOL)visible animated:(BOOL)animated;
- (BOOL)isContentViewVisible;

// If the link is a button link, this will return the activation button.
- (UIButton *)createActivationButton;
@property (nonatomic, strong, readonly) UIButton *activationButton;
- (void)activationButtonPressed:(id)sender;

@end
