//
//  PSPDFTextLine.h
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
