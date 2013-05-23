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
#import "PSPDFShapeAnnotation.h"
#import <QuartzCore/QuartzCore.h>

@class PSPDFDrawView, PSPDFDrawAction;

/// Delegate when drawing is finished.
@protocol PSPDFDrawViewDelegate <NSObject>

@optional

/// Draw View did begin (touching down)
- (void)drawViewDidBeginDrawing:(PSPDFDrawView *)drawView;

/// New sketch, shape or line has been added.
- (void)drawView:(PSPDFDrawView *)drawView didChange:(PSPDFDrawAction *)drawAction;

@end

/// Class that allows drawing on top of a PSPDFPageView.
@interface PSPDFDrawView : UIView

/// Current line width.
@property (nonatomic, assign) CGFloat lineWidth;

/// Current stroke color.
@property (nonatomic, strong) UIColor *strokeColor;

/// Path of the current draw operation.
@property (nonatomic, strong, readonly) UIBezierPath *path;

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

/// Current shape annotation type (to be specified when annotationType is PSPDFAnnotationTypeShape).
@property (nonatomic, assign) PSPDFShapeAnnotationType shapeType;

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

@end

@interface PSPDFDrawView (SubclassingHooks)

// Current active drawing.
@property (nonatomic, strong, readonly) CAShapeLayer *shapeLayer;

@end


// Single draw action.
@interface PSPDFDrawAction : NSObject

// Points that are in this drawing action.
@property (nonatomic, copy, readonly) NSArray *points;

// Stroke color.
@property (nonatomic, strong, readonly) UIColor *strokeColor;

// Line width.
@property (nonatomic, assign, readonly) CGFloat lineWidth;

@end
