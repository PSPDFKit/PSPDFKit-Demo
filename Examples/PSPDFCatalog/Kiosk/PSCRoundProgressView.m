//
//  PSCRoundProgressView.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCRoundProgressView.h"
#import <tgmath.h>

@interface PSCRoundProgressView ()
@property (nonatomic, strong) CAShapeLayer *backgroundShape;
@property (nonatomic, strong) CAShapeLayer *progressShape;
@end

@implementation PSCRoundProgressView

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.alpha = 0.45f;

        self.progressShape = [CAShapeLayer layer];
        self.progressShape.fillColor = UIColor.clearColor.CGColor;
        self.progressShape.strokeColor = UIColor.blackColor.CGColor;
        [self.layer addSublayer:self.progressShape];

        self.backgroundShape = [CAShapeLayer layer];
        self.backgroundShape.fillColor = UIColor.blackColor.CGColor;
        self.backgroundShape.anchorPoint = CGPointMake(0.5f, 0.5f);
        self.backgroundShape.contentsGravity = kCAGravityCenter;
        self.backgroundShape.fillRule = kCAFillRuleEvenOdd;
        [self.layer addSublayer:self.backgroundShape];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];

    // rects
    CGRect bounds = self.bounds;
    CGFloat centerHoleInset = 0.2f * CGRectGetWidth(bounds);
    CGFloat progressShapeInset = 0.025f * CGRectGetWidth(bounds);

    // progress shape
    CGFloat radius = (CGRectGetWidth(bounds) - (2 * centerHoleInset) - (2 * progressShapeInset)) / 2.0f;
    CGRect progressRect = CGRectMake((CGRectGetWidth(bounds) / 2.0f) - (radius / 2.0f),
                                     (CGRectGetHeight(bounds) / 2.0f) - (radius / 2.0f),
                                     radius, radius);
    self.progressShape.path = [UIBezierPath bezierPathWithRoundedRect:progressRect cornerRadius:radius].CGPath;
    self.progressShape.lineWidth = radius;

    // box shape
    CGFloat boxDiameter = CGRectGetWidth(self.bounds) - centerHoleInset * 2;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:bounds];
    [path appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectMake((CGRectGetWidth(bounds) / 2.0f) - (boxDiameter / 2.0f),
                                                                       (CGRectGetHeight(bounds) / 2.0f) - (boxDiameter / 2.0f),
                                                                       boxDiameter, boxDiameter)]];
    path.usesEvenOddFillRule = YES;
    self.backgroundShape.path = path.CGPath;
    self.backgroundShape.bounds = bounds;
    self.backgroundShape.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)setProgress:(CGFloat)progress {
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    progress = pubrange(0.f, progress, 1.f);
    if (progress != _progress) {
        self.hidden = NO;

        [CATransaction begin];
        [CATransaction setAnimationDuration:animated ? 0.5f : 0.f];
        self.progressShape.strokeStart = progress;
        [CATransaction commit];

        if ((_progress == 1.0f && progress < 1.0f) || !animated) {
            [self.backgroundShape removeAllAnimations];
        }
        if (progress == 1.0f) {
            if (animated) {
                [CATransaction begin]; {
                    [CATransaction setCompletionBlock:^{
                        self.hidden = YES;
                    }];
                    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                    scaleAnimation.toValue = @(3.f); // scale factor
                    scaleAnimation.duration = 0.5f;
                    scaleAnimation.removedOnCompletion = NO;
                    scaleAnimation.autoreverses = NO;
                    scaleAnimation.fillMode = kCAFillModeForwards;
                    [self.backgroundShape addAnimation:scaleAnimation forKey:@"transform.scale"];
                } [CATransaction commit];
            } else {
                self.hidden = YES;
            }
        }

        _progress = progress;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

inline static CGFloat pubrange(CGFloat minRange, CGFloat value, CGFloat maxRange) {
    return __tg_fmin(__tg_fmax(value, minRange), __tg_fmax(minRange, maxRange));
}

@end
