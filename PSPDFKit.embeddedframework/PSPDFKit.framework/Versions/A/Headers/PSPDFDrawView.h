//
//  PSPDFDrawView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFSquareAnnotation.h"
#import "PSPDFPolygonAnnotation.h"
#import "PSPDFLineHelper.h"
#import "PSPDFAnnotationViewProtocol.h"
#import <QuartzCore/QuartzCore.h>

@class PSPDFDrawView, PSPDFDrawAction, PSPDFPageView, PSPDFUndoController;

typedef NS_ENUM(NSInteger, PSPDFDrawViewInputMode) {
    /// Touches perform drawing operations.
    PSPDFDrawViewInputModeDraw,
    /// Touches perform erase operations.
    PSPDFDrawViewInputModeErase
};

// Adds the ability to animate CALayers changes (mainly for auto-rotation support)
@protocol PSPDFAnimatableShapeUpdates <NSObject>
// Animate changes (enable before rotation, disable afterwards)
@property (nonatomic, assign) BOOL animateShapeBoundsChanges;
// The shape bound change animation (match this to the rotation duration)
@property (nonatomic, assign) NSTimeInterval shapeBoundsChangeAnimationDuration;
@end

/// `PSPDFDrawView` allows drawing or erasing on top of a `PSPDFPageView` and handles new annotation creation.
/// The class holds an array of `PSPDFDrawAction` objects that will later be converted into PDF annotations
/// (`PSPDFAnnotation` and it's subclasses). The conversion from draw view to annotation isn't necessary 1:1.
/// Some draw actions can be left out (for instance if there are validation errors like to few points for the annotation
/// type in question). Others might be combined into a single annotation (see `combineInk`).
@interface PSPDFDrawView : UIView <PSPDFAnnotationViewProtocol, PSPDFUndoProtocol, PSPDFAnimatableShapeUpdates>

/// Current annotation type.
@property (nonatomic, assign) PSPDFAnnotationType annotationType;

/// Determines what effect touch events have. Defaults to `PSPDFDrawViewInputModeDraw`.
/// `PSPDFDrawViewInputModeErase` only affects Ink annotations.
@property (nonatomic, assign) PSPDFDrawViewInputMode inputMode;

/// Current active draw action, not yet added to `actionList`. This action is currently receiving input.
@property (nonatomic, strong, readonly) PSPDFDrawAction *currentAction;

/// Array of `PSPDFDrawAction` objects that have been created during the draw view session
// or imported using `updateActionsForAnnotations:`.
@property (nonatomic, strong, readonly) NSArray *actionList;

/// Clear all actions. Doesn't count as undo/redo operation (clears the related undo history).
- (void)clearAllActions;

/// Advanced property that allows you to customize how ink annotations are created.
/// Set to NO to cause separate ink drawings in the same drawing session to result in separate ink annotations. Defaults to YES.
@property (nonatomic, assign) BOOL combineInk;

/// @name Styling properties

/// Current stroke color.
@property (nonatomic, strong) UIColor *strokeColor;

/// Current fill color.
@property (nonatomic, strong) UIColor *fillColor;

/// Current line width.
@property (nonatomic, assign) CGFloat lineWidth;

/// Starting line end type for lines and polylines.
@property (nonatomic, assign) PSPDFLineEndType lineEnd1;

/// Ending line end type for lines and polylines.
@property (nonatomic, assign) PSPDFLineEndType lineEnd2;

/// @name Undo/Redo

/// The managing undo controller. Set this to the document's undo controller.
/// Defaults to nil (no undo tracking).
@property (nonatomic, strong) PSPDFUndoController *undoController;

/// Removes all undo actions related to the draw view and it's actions.
- (void)removeUndoHistory;

/// @name Annotation import and export

/// Converts the provided annotations into `PSPDFDrawAction` objects, making them available for editing, and
/// removes existing `PSPDFDrawAction` objects tied to annotations, that are no longer in the `annotations` array.
/// @note Currently only supports Ink annotations (ink eraser).
- (void)updateActionsForAnnotations:(NSArray *)annotations;

/// Converts newly created draw actions into annotations (excluding imported annotations - update those using
/// `writeChangesToAnnotations`). You can subclass this method to add support custom annotations (call super,
/// iterate over the actionList and add your custom annotations to the returned array).
- (NSArray *)newAnnotationsFromActionsList;

/// Saves changes to annotations that were imported using `updateActionsForAnnotations:`.
- (void)writeChangesToAnnotations;

/// Used to compute approximate line widths during drawing.
/// When a `pageView` is associated this will automatically be set to it's `scaleForPageView`.
/// Defaults to 1.f.
@property (nonatomic, assign) CGFloat scale;

/// Draw view zoom scale, used for zoom dependent eraser sizing.
/// When a `pageView` is associated this will automatically be set to it's `scrollView.zoomScale`.
/// Defaults to 1.f.
@property (nonatomic, assign) CGFloat zoomScale;

@end

@interface PSPDFDrawView (SubclassingHooks)

// Drawing
- (BOOL)shouldProcessTouches:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)startDrawingAtPoint:(CGPoint)location;
- (void)continueDrawingAtPoint:(CGPoint)location;
- (void)endDrawing;    // commits
- (void)cancelDrawing; // cancels

@end

