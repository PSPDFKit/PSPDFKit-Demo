//
//  PSPDFGraphicsState.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
