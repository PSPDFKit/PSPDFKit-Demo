//
//  PSPDFGraphicsState.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFFontInfo;

@interface PSPDFGraphicsState : NSObject <NSCopying> {
    // tuned for speed, thus no properties
    @public
    CGAffineTransform textMatrix;
    CGAffineTransform lineMatrix;
    CGAffineTransform ctm;
    CGFloat fontSize;
    CGFloat characterSpacing;
    CGFloat wordSpacing;
    CGFloat horizontalScaling;
    CGFloat leading;
    CGFloat rise;
}

@property(nonatomic, strong) PSPDFFontInfo *font;

@end
