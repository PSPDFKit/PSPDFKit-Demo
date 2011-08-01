//
//  AMGridView.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFGridView.h"

@implementation PSPDFGridView

// for uinavigationbar shadow
#define SHADOW_HEIGHT 20.0
#define SHADOW_INVERSE_HEIGHT 10.0
#define SHADOW_RATIO (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT)

- (CAGradientLayer *)shadowAsInverse:(BOOL)inverse {
    CAGradientLayer *newShadow = [[[CAGradientLayer alloc] init] autorelease];
    CGRect newShadowFrame =
    CGRectMake(0, 0, self.frame.size.width,
               inverse ? SHADOW_INVERSE_HEIGHT : SHADOW_HEIGHT);
    newShadow.frame = newShadowFrame;
    CGColorRef darkColor =
    [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:
     inverse ? (SHADOW_INVERSE_HEIGHT / SHADOW_HEIGHT) * 0.5 : 0.5].CGColor;
    CGColorRef lightColor =
    [self.backgroundColor colorWithAlphaComponent:0.0].CGColor;
    newShadow.colors =
    [NSArray arrayWithObjects:
     (id)(inverse ? lightColor : darkColor),
     (id)(inverse ? darkColor : lightColor),
     nil];
    return newShadow;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //
    // Construct the origin shadow if needed
    //
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
    originShadowFrame.origin.y = self.contentOffset.y;
    originShadow_.frame = originShadowFrame;
    
    [CATransaction commit];
}

@end
