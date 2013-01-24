//
//  PSPDFSelectionBorderView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFLongPressGestureRecognizer.h"

@class PSPDFResizableView;

///
/// Delegate to be notified on session begin/end and frame changes.
///
@protocol PSPDFResizableViewDelegate <NSObject>

@optional

/// The editing session has begun.
- (void)resizableViewDidBeginEditing:(PSPDFResizableView *)resizableView;

/// Called after frame change.
- (void)resizableViewChangedFrame:(PSPDFResizableView *)resizableView;

/// The editing session has ended.
- (void)resizableViewDidEndEditing:(PSPDFResizableView *)resizableView;

@end

///
/// If trackedView responds to this delegate, we will set it.
///
@protocol PSPDFResizableTrackedViewDelegate <NSObject>

/// The resizable tracker, if currently available.
@property (nonatomic, weak) PSPDFResizableView *resizableView;

@end

typedef NS_ENUM(NSUInteger, PSPDFSelectionBorderKnobType) {
    PSPDFSelectionBorderKnobTypeNone,
    PSPDFSelectionBorderKnobTypeMove,
    PSPDFSelectionBorderKnobTypeTopLeft,
    PSPDFSelectionBorderKnobTypeTopMiddle,
    PSPDFSelectionBorderKnobTypeTopRight,
    PSPDFSelectionBorderKnobTypeMiddleLeft,
    PSPDFSelectionBorderKnobTypeMiddleRight,
    PSPDFSelectionBorderKnobTypeBottomLeft,
    PSPDFSelectionBorderKnobTypeBottomMiddle,
    PSPDFSelectionBorderKnobTypeBottomRight
};

///
/// Handles view selection with resize knobs.
///
@interface PSPDFResizableView : UIView <PSPDFLongPressGestureRecognizerDelegate>

/// Designated initializer.
/// This will call self.trackedView, so trackedView is the place where you'd want to override to dynamically set allowResizing.
- (id)initWithTrackedView:(UIView *)trackedView;

/// View that will be changed on selection change.
@property (nonatomic, strong) UIView *trackedView;

/// Set zoomscale to be able to draw the page knobs at the correct size.
@property (nonatomic, assign) CGFloat zoomScale;

/// If set to NO, won't show selection knobs and dragging. Defaults to YES.
@property (nonatomic, assign) BOOL allowEditing;

/// Allows view resizing, shows resize knobs.
/// If set to NO, view can only be moved, no resize knobs will be displayed. Depends on allowEditing. Defaults to YES.
@property (nonatomic, assign) BOOL allowResizing;

/// Set minimum allowed width (unless the view is smaller to begin width). Default is 32.0.
@property (nonatomic, assign) CGFloat minWidth;

/// Set minimum allowed height (unless the view is smaller to begin width). Default is 32.0.
@property (nonatomic, assign) CGFloat minHeight;

/// Disables dragging the view outside of the parent. Defaults to YES.
@property (nonatomic, assign) BOOL preventsPositionOutsideSuperview;

/// Active knob when we're dragging.
@property (nonatomic, assign) PSPDFSelectionBorderKnobType activeKnobType;

// forward parent gesture recognizer longPress action.
- (BOOL)longPress:(UILongPressGestureRecognizer *)recognizer;

/// Delegate called on frame change.
@property (nonatomic, weak) id<PSPDFResizableViewDelegate> delegate;

@end
