//
//  PSPDFTextLine.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFWord.h"

typedef enum {
    PSPDFTextLineBorderUndefined = 0,
    PSPDFTextLineBorderTopDown,  // 1
    PSPDFTextLineBorderBottomUp, // 2
    PSPDFTextLineBorderNone      // 3
}PSPDFTextLineBorder;

@interface PSPDFTextLine : PSPDFWord

@property (nonatomic, ps_weak, readonly) PSPDFTextLine *prevLine;
@property (nonatomic, ps_weak, readonly) PSPDFTextLine *nextLine;

- (void)setNextLineIfCloserDistance:(PSPDFTextLine *)nextLine;
- (void)setPrevLineIfCloserDistance:(PSPDFTextLine *)prevLine;

@property(nonatomic, assign, readonly) PSPDFTextLineBorder borderType;

@property(nonatomic, assign) NSInteger blockID;

@end
