//
//  PSCMultilineDocumentTitleExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"
#import "PSCKioskPDFViewController.h"

@interface PSCMultilineDocumentTitleExample : PSCExample @end
@implementation PSCMultilineDocumentTitleExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Multiline document title";
        self.category = PSCExampleCategoryViewCustomization;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
	document.title = @"This PDF document has a pretty long title. It should wrap into multiple lines on an iPhone.";
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

	// The standard numberOfLines conventions apply here (0 = use as many lines as needed)
	pdfController.HUDView.documentLabel.label.numberOfLines = 0;

	// The document label is disabled by default on the iPad. If you're expecting long titles
	// and want make sure they are always shown in full on the iPad, you should set `documentLabelEnabled` to `YES` explicity.
	//pdfController.HUDView.documentLabelEnabled = YES;

	return pdfController;
}

@end
