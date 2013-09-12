//
//  PSPDFDrawView.h
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
#import "PSPDFSquareAnnotation.h"
#import "PSPDFPolygonAnnotation.h"
#import "PSPDFLineHelper.h"
#import <QuartzCore/QuartzCore.h>

@class PSPDFDrawView, PSPDFDrawAction;

/// Delegate when drawing is finished.
@protocol PSPDFDrawViewDelegate <NSObject>

@optional

/// Draw View did begin (touching down)
- (void)drawViewDidBeginDrawing:(PSPDFDrawView *)drawView;

/// New sketch, shape, line or polygon has been added.
- (void)drawView:(PSPDFDrawView *)drawView didChange:(PSPDFDrawAction *)drawAction isNew:(BOOL)isNew;

@end

/// Class that allows drawing on top of a PSPDFPageView.
@interface PSPDFDrawView : UIView

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

/// Path of the current draw operation.
@property (nonatomic, strong, readonly) UIBezierPath *strokePath;

/// Array of dictionaries of all lines, including color and width used.
/// If you want to create a PSPDFInkAnnotation from this, convert the points to PDF coordinates first.
@property (nonatomic, strong, readonly) NSArray *actionList;

/// Draw view zoom scale. Defaults to 1. Increase to allow sharp rendering when zoomed in.
/// @warning Allows maximum zoomScale of 5. Will be disabled for older devices (iPad1)
@property (nonatomic, assign) CGFloat zoomScale;

/// Scale value for the page on which drawing occurs.
/// Used to compute approximate line widths during drawing.
@property (nonatomic, assign) CGFloat scale;

/// Current annotation type.
@property (nonatomic, assign) PSPDFAnnotationType annotationType;

/// Draw Delegate.
@property (atomic, weak) IBOutlet id<PSPDFDrawViewDelegate> delegate;


/// @name Undo/Redo

/// Undo possible?
- (BOOL)canUndo;

/// Undo last action, update view.
- (BOOL)undo;

/// Redo possible?
- (BOOL)canRedo;

/// Redo last action, update view.
- (BOOL)redo;

/// Clear all actions. No delegate method will be called. Doesn't count as undo/redo operation.
- (void)clearAllActions;

@end

@interface PSPDFDrawView (SubclassingHooks)

// Current active drawing layers.
@property (nonatomic, strong, readonly) CAShapeLayer *strokeLayer;
@property (nonatomic, strong, readonly) CAShapeLayer *fillLayer;
@property (nonatomic, strong, readonly) CALayer *previewLayer;

@end


// Single draw action.
@interface PSPDFDrawAction : NSObject

// Points that are in this drawing action.
@property (nonatomic, copy, readonly) NSArray *points;

// Stroke color.
@property (nonatomic, strong, readonly) UIColor *strokeColor;

// Fill color.
@property (nonatomic, strong, readonly) UIColor *fillColor;

// Line width.
@property (nonatomic, assign, readonly) CGFloat lineWidth;

/// Starting line end type for lines and polylines.
@property (nonatomic, assign, readonly) PSPDFLineEndType lineEnd1;

/// Ending line end type for lines and polylines.
@property (nonatomic, assign, readonly) PSPDFLineEndType lineEnd2;

@end
