//
//  PSPDFDrawView.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
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

/// Draw Delegate.
@property (atomic, weak) id<PSPDFDrawViewDelegate> delegate;

- (BOOL)canUndo;
- (BOOL)undo;
- (BOOL)canRedo;
- (BOOL)redo;

@end

@interface PSPDFDrawView (SubclassingHooks)

/// For a fast drawing preview.
@property (nonatomic, strong, readonly) CAShapeLayer *shapeLayer;

@end


// Single draw action. (saved for undo/redo)
@interface PSPDFDrawAction : NSObject

@property (nonatomic, copy) NSArray *points;

- (id)initWithPoints:(NSArray *)pointArray path:(UIBezierPath *)bezierPath type:(NSString *)actionType strokeColor:(UIColor *)color lineWidth:(CGFloat)width;

- (void)apply;

@end
