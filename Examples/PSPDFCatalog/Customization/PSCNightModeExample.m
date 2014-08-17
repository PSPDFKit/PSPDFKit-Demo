//
//  PSCNightModeExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCNightModeExample : PSCExample @end
@implementation PSCNightModeExample

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Night Mode";
        self.contentDescription = @"Inverts color for PDF rendering.";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 50;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    // Set up the document.
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.UID = @"NIGHT_MODE"; // different UID to not influence other examples.
    document.renderOptions = @{PSPDFRenderInvertedKey : @YES};
    document.backgroundColor = UIColor.blackColor;

    // And also the controller.
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.backgroundColor = UIColor.blackColor;
    pdfController.createAnnotationMenuEnabled = NO;
    return pdfController;
}

@end
