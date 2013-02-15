//
//  PSPDFDrawView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import <QuartzCore/QuartzCore.h>

@class PSPDFDrawView, PSPDFDrawAction;

/// Delegate when drawing is finished.
@protocol PSPDFDrawViewDelegate <NSObject>

@optional

/// Draw View did begin (touching down)
- (void)drawViewDidBeginDrawing:(PSPDFDrawView *)drawView;

/// New line has been added.
- (void)drawView:(PSPDFDrawView *)drawView didChange:(PSPDFDrawAction *)drawAction;

@end

/// Class that allows drawing on top of a PSPDFPageView.
@interface PSPDFDrawView : UIView

/// Current line width.
@property (nonatomic, assign) CGFloat lineWidth;

/// Current stroke color.
@property (nonatomic, strong) UIColor *strokeColor;

/// Path of the whole draw operation.
@property (nonatomic, strong, readonly) UIBezierPath *path;

// Used in linesDictionary array.
extern NSString *const kPSPDFPointsKey;
extern NSString *const kPSPDFWidthKey;
extern NSString *const kPSPDFColorKey;

/// Array of dictionaries of all lines, including color and width used.
/// If you want to create a PSPDFInkAnnotation from this, convert the points to PDF coordinates first.
@property (nonatomic, strong, readonly) NSArray *linesDictionaries;

/// Draw view zoom scale. Defaults to 1. Increase to allow sharp rendering when zoomed in.
/// @warning Allows maximum zoomScale of 5. Will be disabled for older devices (iPad1)
@property (nonatomic, assign) CGFloat zoomScale;

/// Draw Delegate.
@property (atomic, weak) IBOutlet id<PSPDFDrawViewDelegate> delegate;

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

// For a fast drawing preview.
@property (nonatomic, strong, readonly) CAShapeLayer *shapeLayer;

// Drawings are cached.
@property (nonatomic, strong) UIImage *currentImage;

@end


// Single draw action. (saved for undo/redo)
@interface PSPDFDrawAction : NSObject

// Points that are in this drawing action.
@property (nonatomic, copy) NSArray *points;

// Designated initializer.
- (id)initWithPoints:(NSArray *)pointArray path:(UIBezierPath *)bezierPath type:(NSString *)actionType strokeColor:(UIColor *)color lineWidth:(CGFloat)width;

// Apply action to the current UI image context.
- (void)apply;

@end
