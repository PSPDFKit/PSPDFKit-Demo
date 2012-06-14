//
//  PSPDFGraphicsState.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PSPDFFontInfo;

@interface PSPDFGraphicsState : NSObject <NSCopying>

@property (nonatomic, assign) CGAffineTransform textMatrix;
@property (nonatomic, assign) CGAffineTransform lineMatrix;
@property (nonatomic, assign) CGAffineTransform ctm;
@property (nonatomic, strong) PSPDFFontInfo *font;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat characterSpacing;
@property (nonatomic, assign) CGFloat wordSpacing;
@property (nonatomic, assign) CGFloat horizontalScaling;
@property (nonatomic, assign) CGFloat leading;
@property (nonatomic, assign) CGFloat rise;

@end
