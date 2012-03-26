//
//  PSPDFShadowView.m
//  PSPDFKitExample
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFShadowView.h"
#import <QuartzCore/QuartzCore.h>

@interface PSPDFShadowView() {
    CAGradientLayer *originShadow_;
    BOOL shadowEnabled_;
}
@end

@implementation PSPDFShadowView

@synthesize shadowEnabled = shadowEnabled_;
@synthesize shadowOffset = shadowOffset_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        shadowEnabled_ = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self  = [super initWithFrame:frame])) {
        shadowEnabled_ = YES;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

// for uinavigationbar shadow
#define SHADOW_HEIGHT 20.0
#define SHADOW_INVERSE_HEIGHT 10.0
#define SHADOW_RATIO (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT)

- (CAGradientLayer *)shadowAsInverse:(BOOL)inverse {
    CAGradientLayer *newShadow = [[CAGradientLayer alloc] init];
    CGRect newShadowFrame = CGRectMake(0.f, 0.f, self.frame.size.width,inverse ? SHADOW_INVERSE_HEIGHT : SHADOW_HEIGHT);
    newShadow.frame = newShadowFrame;
    
    UIColor *lightColor = [self.backgroundColor colorWithAlphaComponent:0.f];
    UIColor *darkColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:inverse ? (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT) * 0.5f : 0.5f];

    if (inverse) {
        newShadow.colors = [NSArray arrayWithObjects:(__bridge id)lightColor.CGColor, (__bridge id)darkColor.CGColor, nil];
    }else {
        newShadow.colors = [NSArray arrayWithObjects:(__bridge id)darkColor.CGColor, (__bridge id)lightColor.CGColor, nil];
    }
    return newShadow;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isShadowEnabled) {
        // Construct the origin shadow if needed
        if (!originShadow_) {
            originShadow_ = [self shadowAsInverse:NO];
            [self.layer insertSublayer:originShadow_ atIndex:9999];
        }
        else if (![[self.layer.sublayers objectAtIndex:0] isEqual:originShadow_]) {
            [self.layer insertSublayer:originShadow_ atIndex:9999];
        }
        
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        
        // Stretch and place the origin shadow
        CGRect originShadowFrame = originShadow_.frame;
        originShadowFrame.size.width = self.frame.size.width;
        originShadowFrame.origin.y = shadowOffset_;
        originShadow_.frame = originShadowFrame;
        
        [CATransaction commit];
    }else {
        if (originShadow_) {
            [originShadow_ removeFromSuperlayer];
            originShadow_ = nil;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)setShadowOffset:(CGFloat)shadowOffset {
    shadowOffset_ = shadowOffset;
    [self setNeedsLayout];
}

- (void)setShadowEnabled:(BOOL)shadowEnabled {
    shadowEnabled_ = shadowEnabled;
    [self setNeedsLayout];
}

@end
