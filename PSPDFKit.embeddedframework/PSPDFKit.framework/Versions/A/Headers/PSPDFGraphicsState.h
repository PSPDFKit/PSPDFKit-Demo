//
//  PSPDFGraphicsState.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFFontInfo;

@interface PSPDFGraphicsState : NSObject <NSCopying> {
    // tuned for speed, thus no properties
    @public
    PSPDFFontInfo *font;
    CGAffineTransform textMatrix;
    CGAffineTransform lineMatrix;
    CGAffineTransform ctm;
    CGFloat fontSize;
    CGFloat characterSpacing;
    CGFloat wordSpacing;
    CGFloat horizontalScaling;
    CGFloat leading;
    CGFloat rise;
    NSUInteger renderingMode;
}

@property (nonatomic, strong) PSPDFFontInfo *font;

@end
