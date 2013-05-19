//
//  PSPDFTextLine.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
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

@property (nonatomic, unsafe_unretained, readonly) PSPDFTextLine *prevLine;
@property (nonatomic, unsafe_unretained, readonly) PSPDFTextLine *nextLine;

void PSPDFSetNextLineIfCloserDistance(__unsafe_unretained PSPDFTextLine *self, __unsafe_unretained PSPDFTextLine *nextLine);
void PSPDFSetPrevLineIfCloserDistance(__unsafe_unretained PSPDFTextLine *self, __unsafe_unretained PSPDFTextLine *prevLine);

@property (nonatomic, assign, readonly) PSPDFTextLineBorder borderType;

@property (nonatomic, assign) NSInteger blockID;

@end
