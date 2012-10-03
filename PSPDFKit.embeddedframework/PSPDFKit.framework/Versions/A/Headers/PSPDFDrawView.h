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

- (void)drawViewDidFinish:(PSPDFDrawView *)drawView;

@optional

- (void)drawViewDidBeginDrawing:(PSPDFDrawView *)drawView;
- (void)drawView:(PSPDFDrawView *)drawView didChange:(PSPDFDrawAction *)drawAction;

@end


/// Class that allows drawing on top of a PSPDFPageView.
@interface PSPDFDrawView : UIView

@property (nonatomic, strong, readonly) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) BOOL hasChanges;
@property (nonatomic, strong) UIPopoverController *activePopover;

/// Draw Delegate.
@property (nonatomic, unsafe_unretained) id<PSPDFDrawViewDelegate> delegate;

- (void)loadImage:(UIImage *)image;
- (BOOL)canUndo;
- (BOOL)undo;
- (BOOL)canRedo;
- (BOOL)redo;
- (void)done;

@end


// Single draw action (saved for undo/redo)
@interface PSPDFDrawAction : NSObject

@property (nonatomic, strong) NSArray *points;

- (id)initWithPoints:(NSArray *)pointArray path:(UIBezierPath *)bezierPath type:(NSString *)actionType strokeColor:(UIColor *)color lineWidth:(CGFloat)width;

- (void)apply;

@end
