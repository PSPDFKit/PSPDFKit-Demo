//
//  PSPDFIconGenerator.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

enum {
    PSPDFIconTypeOutline,
    PSPDFIconTypePage,
    PSPDFIconTypeThumbnails,
    PSPDFIconTypeBackArrow,
    PSPDFIconTypeBackArrowSmall,
    PSPDFIconTypeForwardArrow,
    PSPDFIconTypePrint
}typedef PSPDFIconType;

/// Generates various Icons on the fly and caches them for later use.
@interface PSPDFIconGenerator : NSObject

/// Access singleton. Note: can be overridden with changing global kPSPDFIconGeneratorClassName.
+ (PSPDFIconGenerator *)sharedGenerator;

/// Generates in-code images on the fly. Cached, Thread-safe.
- (UIImage *)iconForType:(PSPDFIconType)iconType;

@end
