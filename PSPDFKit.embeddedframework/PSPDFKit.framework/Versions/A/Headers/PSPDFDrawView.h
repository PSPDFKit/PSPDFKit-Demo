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

- (void)drawViewDidBeginDrawing:(PSPDFDrawView *)drawView;
- (void)drawView:(PSPDFDrawView *)drawView didChange:(PSPDFDrawAction *)drawAction;

@end

/// Class that allows drawing on top of a PSPDFPageView.
@interface PSPDFDrawView : UIView

/// Current line width.
@property (nonatomic, assign) CGFloat lineWidth;

/// Current stroke color.
@property (nonatomic, strong) UIColor *strokeColor;

/// path/lines
@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) NSMutableArray *lines;

/// For a fast drawing preview.
@property (nonatomic, strong, readonly) CAShapeLayer *shapeLayer;

/// Draw Delegate.
@property (atomic, weak) id<PSPDFDrawViewDelegate> delegate;

- (BOOL)canUndo;
- (BOOL)undo;
- (BOOL)canRedo;
- (BOOL)redo;

@end


// Single draw action (saved for undo/redo)
@interface PSPDFDrawAction : NSObject

@property (nonatomic, copy) NSArray *points;

- (id)initWithPoints:(NSArray *)pointArray path:(UIBezierPath *)bezierPath type:(NSString *)actionType strokeColor:(UIColor *)color lineWidth:(CGFloat)width;

- (void)apply;

@end
