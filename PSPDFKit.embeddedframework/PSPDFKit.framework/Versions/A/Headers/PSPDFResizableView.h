//
//  PSPDFResizableView.h
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
#import "PSPDFLongPressGestureRecognizer.h"

@class PSPDFResizableView, PSPDFAnnotation, PSPDFPageView;

/// Delegate to be notified on session begin/end and frame changes.
@protocol PSPDFResizableViewDelegate <NSObject>

@optional

/// The editing session has begun.
- (void)resizableViewDidBeginEditing:(PSPDFResizableView *)resizableView;

/// Called after frame change.
- (void)resizableViewChangedFrame:(PSPDFResizableView *)resizableView;

/// The editing session has ended.
- (void)resizableViewDidEndEditing:(PSPDFResizableView *)resizableView;

@end

/// If trackedView responds to this delegate, we will set it.
@protocol PSPDFResizableTrackedViewDelegate <NSObject>

/// The resizable tracker, if currently available.
@property (nonatomic, weak) PSPDFResizableView *resizableView;

/// Query the annotation of the tracked view.
- (PSPDFAnnotation *)annotation;

@end

typedef NS_ENUM(NSUInteger, PSPDFResizableViewMode) {
    PSPDFResizableViewModeIdle,   /// Nothing is currently happening.
    PSPDFResizableViewModeMove,   /// The annotation is being moved.
    PSPDFResizableViewModeResize, /// The annotation is being resized.
    PSPDFResizableViewModeAdjust  /// The shape of the annotation is being adjusted.
};

/// Handles view selection with resize knobs.
@interface PSPDFResizableView : UIView <PSPDFLongPressGestureRecognizerDelegate>

/// Designated initializer.
/// This will call self.trackedView, so trackedView is the place where you'd want to override to dynamically set allowResizing.
- (id)initWithTrackedView:(UIView *)trackedView;

/// View that will be changed on selection change.
@property (nonatomic, strong) UIView *trackedView;

/// Set zoomscale to be able to draw the page knobs at the correct size.
@property (nonatomic, assign) CGFloat zoomScale;

/// The inner edge insets are used to create space between the bounding box (blue) and inner knobs (green).
/// Will be applied to the contentFrame to calculate frame if an annotation has more than 2 points. Use negative
/// values to add space around the tracked annotation view. Defaults to -20.0f for top, bottom, right, and left.
@property (nonatomic, assign) UIEdgeInsets innerEdgeInsets;

/// The outer edge insets are used to create space between the bounding box (blue) and the view bounds.
/// Will be applied to the contentFrame to calculate frame. Use negative values to add space around the
/// tracked annnotation view. Defaults to -40.0f for top, bottom, right, and left.
@property (nonatomic, assign) UIEdgeInsets outerEdgeInsets;

/// Returns the edge insets that are currently in effect. This is either UIEdgeInsetsZero or innerEdgeInsets.
- (UIEdgeInsets)effectiveInnerEdgeInsets;

/// Returns the edge insets that are currently in effect. This is outerEdgeInsets / zoomScale.
- (UIEdgeInsets)effectiveOuterEdgeInsets;

/// If set to NO, won't show selection knobs and dragging. Defaults to YES.
@property (nonatomic, assign) BOOL allowEditing;

/// Allows view resizing, shows resize knobs.
/// If set to NO, view can only be moved or adjusted, no resize knobs will be displayed. Depends on allowEditing. Defaults to YES.
@property (nonatomic, assign) BOOL allowResizing;

/// Allows view adjusting, shows knobs to move single points.
/// If set to NO, view can only be moved or resized, no adjust knobs will be displayed. Depends on allowEditing. Defaults to YES.
@property (nonatomic, assign) BOOL allowAdjusting;

/// Enables resizing helper so that aspect ration can be preserved easily.
/// Defaults to YES.
@property (nonatomic, assign) BOOL enableResizingGuides;

/// Defines how agressive the guide works. Defaults to 20.f
@property (nonatomic, assign) CGFloat guideSnapAllowance;

/// Set minimum allowed width (unless the view is smaller to begin width). Default is 32.0.
@property (nonatomic, assign) CGFloat minWidth;

/// Set minimum allowed height (unless the view is smaller to begin width). Default is 32.0.
@property (nonatomic, assign) CGFloat minHeight;

/// Disables dragging the view outside of the parent. Defaults to YES.
@property (nonatomic, assign) BOOL preventsPositionOutsideSuperview;

/// Border color. Defaults to [[UIColor pspdf_selectionColor] colorWithAlphaComponent:0.6f].
@property (nonatomic, strong) UIColor *selectionBorderColor;

/// Guide color. Defaults to [UIColor pspdf_guideColor].
@property (nonatomic, strong) UIColor *guideBorderColor;

// forward parent gesture recognizer longPress action.
- (BOOL)longPress:(UILongPressGestureRecognizer *)recognizer;

/// Delegate called on frame change.
@property (nonatomic, weak) IBOutlet id<PSPDFResizableViewDelegate> delegate;

/// The frame of the resizable content. This might be smaller than the frame of the view.
/// Changing the content frame affects the frame.
///
/// @warning Always change the view's frame by setting this property. Do not use the frame property directly!
@property (nonatomic, assign) CGRect contentFrame;

/// The mode that the resizable view is currently in.
@property (nonatomic, assign) PSPDFResizableViewMode mode;

/// The associated pageView.
@property (nonatomic, weak) PSPDFPageView *pageView;

@end

@interface PSPDFResizableView (SubclassingHooks)

// All knobs. Can be hidden individually.
// Note that properties like allowEditing/allowReszing will update the hidden property.
// To properly hide a knob, remove it from the superview.
@property (nonatomic, strong, readonly) UIImageView *knobTopLeft;
@property (nonatomic, strong, readonly) UIImageView *knobTopMiddle;
@property (nonatomic, strong, readonly) UIImageView *knobTopRight;
@property (nonatomic, strong, readonly) UIImageView *knobMiddleLeft;
@property (nonatomic, strong, readonly) UIImageView *knobMiddleRight;
@property (nonatomic, strong, readonly) UIImageView *knobBottomLeft;
@property (nonatomic, strong, readonly) UIImageView *knobBottomMiddle;
@property (nonatomic, strong, readonly) UIImageView *knobBottomRight;

@property (nonatomic, strong, readonly) UIImage *outerKnobImage;
@property (nonatomic, strong, readonly) UIImage *innerKnobImage;

@end
