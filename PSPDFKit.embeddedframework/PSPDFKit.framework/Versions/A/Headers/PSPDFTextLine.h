//
//  PSPDFTextLine.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFWord.h"

typedef NS_ENUM(NSInteger, PSPDFTextLineBorder) {
    PSPDFTextLineBorderUndefined = 0,
    PSPDFTextLineBorderTopDown,  // 1
    PSPDFTextLineBorderBottomUp, // 2
    PSPDFTextLineBorderNone      // 3
};

@interface PSPDFTextLine : PSPDFWord

@property (nonatomic, ps_weak, readonly) PSPDFTextLine *prevLine;
@property (nonatomic, ps_weak, readonly) PSPDFTextLine *nextLine;

void PSPDFSetNextLineIfCloserDistance(PSPDFTextLine *self, PSPDFTextLine *nextLine);
void PSPDFSetPrevLineIfCloserDistance(PSPDFTextLine *self, PSPDFTextLine *prevLine);

@property(nonatomic, assign, readonly) PSPDFTextLineBorder borderType;

@property(nonatomic, assign) NSInteger blockID;

@end
