//
//  PSPDFDrawView.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@interface PSPDFDrawView : UIView

@property(nonatomic, strong, readonly) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) UIBezierPath *path;
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) UIImage *currentImage;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, assign) BOOL hasChanges;
@property (nonatomic, unsafe_unretained) id delegate;
@property (nonatomic, strong) UIPopoverController *activePopover;

- (void)loadImage:(UIImage *)image;
- (BOOL)canUndo;
- (void)undo;
- (BOOL)canRedo;
- (void)redo;
@end


// Single draw action (saved for undo/redo)
@interface PSPDFDrawAction : NSObject

@property (nonatomic, strong) NSArray *points;

- (id)initWithPoints:(NSArray *)pointArray path:(UIBezierPath *)bezierPath type:(NSString *)actionType strokeColor:(UIColor *)color lineWidth:(CGFloat)width;

- (void)apply;

@end

@protocol PSPDFDrawViewDelegate <NSObject>

- (void)drawViewDidFinish:(PSPDFDrawView *)drawView;

@optional

- (void)drawViewDidBeginDrawing:(PSPDFDrawView *)drawView;
- (void)drawView:(PSPDFDrawView *)drawView didChange:(PSPDFDrawAction *)drawView;

@end
