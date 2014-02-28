//
//  PSCExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
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

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    return nil;
}

@end

NSString *PSPDFHeaderFromExampleCategory(PSCExampleCategory category) {
    switch (category) {
        case PSCExampleCategoryAnnotations:
            return @"Annotations";
        case PSCExampleCategoryForms:
            return @"Forms and Digital Signatures";
        case PSCExampleCategoryBarButtons:
            return @"Toolbar customizations";
        case PSCExampleCategoryViewCustomization:
            return @"View Customizations";
        case PSCExampleCategoryPageRange:
            return @"Range Range";
        case PSCExampleCategoryDocumentDataProvider:
            return @"PSPDFDocument data providers";
        case PSCExampleCategoryMultimedia:
            return @"Multimedia examples";
        case PSCExampleCategoryStoryboards:
            return @"Storyboards";
        case PSCExampleCategoryTextExtraction:
            return @"Text Extraction / PDF creation";
        case PSCExampleCategoryControllerCustomization:
            return @"PSPDFViewController customization";
        case PSCExampleCategoryAnnotationProviders:
            return @"Annotation Providers";
        default:
            return nil;
    }
}

NSString *PSPDFFooterFromExampleCategory(PSCExampleCategory category) {
    switch (category) {
        case PSCExampleCategoryPageRange:
            return @"With pageRange, the pages visible can be filtered";
        case PSCExampleCategoryDocumentDataProvider:
            return @"PSPDFDocument is highly flexible and allows you to merge multiple file sources to one logical one.";
        case PSCExampleCategoryMultimedia:
            return @"You can integrate videos, audio, images and HTML5 content/websites as parts of a PDF page. See http://pspdfkit.com/documentation for details.";
        case PSCExampleCategoryAnnotations: break;
        case PSCExampleCategoryForms:
            return @"PSPDFKit can show the original signed document even if the document has been subsequently altered.";
        default: break;
    }
    return nil;
}


