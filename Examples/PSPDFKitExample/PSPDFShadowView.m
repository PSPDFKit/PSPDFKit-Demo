//
//  PSPDFShadowView.m
//  PSPDFKitExample
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFShadowView.h"
#import <QuartzCore/QuartzCore.h>

@interface PSPDFShadowView() {
    CAGradientLayer *_originShadow;
}
@end

@implementation PSPDFShadowView

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        _shadowEnabled = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self  = [super initWithFrame:frame])) {
        _shadowEnabled = YES;
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
        newShadow.colors = @[(__bridge id)lightColor.CGColor, (__bridge id)darkColor.CGColor];
    }else {
        newShadow.colors = @[(__bridge id)darkColor.CGColor, (__bridge id)lightColor.CGColor];
    }
    return newShadow;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.isShadowEnabled) {
        // Construct the origin shadow if needed
        if (!_originShadow) {
            _originShadow = [self shadowAsInverse:NO];
            [self.layer insertSublayer:_originShadow atIndex:9999];
        }
        else if (![(self.layer.sublayers)[0] isEqual:_originShadow]) {
            [self.layer insertSublayer:_originShadow atIndex:9999];
        }
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        
        // Stretch and place the origin shadow
        CGRect originShadowFrame = _originShadow.frame;
        originShadowFrame.size.width = self.frame.size.width;
        originShadowFrame.origin.y = _shadowOffset;
        _originShadow.frame = originShadowFrame;
        
        [CATransaction commit];
    }else {
        if (_originShadow) {
            [_originShadow removeFromSuperlayer];
            _originShadow = nil;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)setShadowOffset:(CGFloat)shadowOffset {
    _shadowOffset = shadowOffset;
    [self setNeedsLayout];
}

- (void)setShadowEnabled:(BOOL)shadowEnabled {
    _shadowEnabled = shadowEnabled;
    [self setNeedsLayout];
}

@end
