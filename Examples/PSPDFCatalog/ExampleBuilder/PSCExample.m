//
//  PSCExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"

@implementation PSCExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        _targetDevice = PSCExampleTargetDeviceMaskPhone|PSCExampleTargetDeviceMaskPad;
    }
    return self;
}

- (UIViewController *)invoke {
    return nil;
}

@end

NSString *PSPDFHeaderFromExampleCategory(PSCExampleCategory category) {
    switch (category) {
        case PSCExampleCategoryAnnotations:
            return @"Annotations";
        case PSCExampleCategoryBarButtons:
            return @"BarButtons";
        case PSCExampleCategoryViewCustomization:
            return @"ViewCustomization";
        case PSCExampleCategoryPageRange:
            return @"PageRange";
        case PSCExampleCategoryDocumentDataProvider:
            return @"PSPDFDocument data providers";
        default:
            return nil;
    }
}

NSString *PSPDFFooterFromExampleCategory(PSCExampleCategory category) {
    switch (category) {
        case PSCExampleCategoryPageRange:
            return @"With pageRange, the pages visible can be filtered";
        case PSCExampleCategoryAnnotations:
        case PSCExampleCategoryBarButtons:
        case PSCExampleCategoryViewCustomization:
        case PSCExampleCategoryDocumentDataProvider:
            return @"PSPDFDocument is highly flexible and allows you to merge multiple file sources to one logical one.";
        default:
            return nil;
    }
}


