//
//  PSCSearchHighlightColorExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCCustomColoredSearchHighlightPDFViewController : PSPDFViewController @end

@interface PSCSearchHighlightColorExample : PSCExample @end
@implementation PSCSearchHighlightColorExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Custom Search Highlight Color";
        self.contentDescription = @"Changes the search highlight color to blue via UIAppearance.";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 50;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];

    // We use a custom subclass of the PSPDFViewController here, to not pollute other examples, since UIAppearance can't be re-set to the default.
    [PSPDFSearchHighlightView appearanceWhenContainedIn:PSCCustomColoredSearchHighlightPDFViewController.class, nil].selectionBackgroundColor = [UIColor.blueColor colorWithAlphaComponent:0.5f];

    PSPDFViewController *pdfController = [[PSCCustomColoredSearchHighlightPDFViewController alloc] initWithDocument:document];

    // We're lazy - automatically start search.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [pdfController searchForString:@"Tom" options:nil sender:nil animated:YES];
    });

    return pdfController;
}

@end

@implementation PSCCustomColoredSearchHighlightPDFViewController @end
