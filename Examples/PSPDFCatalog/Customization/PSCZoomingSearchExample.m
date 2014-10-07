//
//  PSCZoomingSearchExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCZoomingSearchPDFViewController : PSPDFViewController

@property (nonatomic, assign) dispatch_once_t searchPresentationOnceToken;

@end

@interface PSCZoomingSearchExample : PSCExample @end
@implementation PSCZoomingSearchExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Zooming Search Results";
        self.category = PSCExampleCategoryViewCustomization;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSCZoomingSearchPDFViewController alloc] initWithDocument:document];
    
    [pdfController updateConfigurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        builder.searchMode = PSPDFSearchModeModal;
    }];
    
    return pdfController;
}

@end

@implementation PSCZoomingSearchPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Prevents search to reappear when PSPDFSearchViewController is dismissed.
    dispatch_once(&_searchPresentationOnceToken, ^{
        // Automatically start searching.
        [self searchForString:@"Tomat" options:nil sender:nil animated:YES];
    });
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFSearchViewControllerDelegate

- (void)searchViewController:(PSPDFSearchViewController *)searchController didTapSearchResult:(PSPDFSearchResult *)searchResult {
    [super searchViewController:searchController didTapSearchResult:searchResult];
    
    CGRect viewRect = [[self pageViewForPage:searchResult.pageIndex] convertPDFRectToViewRect:searchResult.selection.frame];
    //    viewRect = CGRectInset(viewRect, 20.f, 20.f); // leave some space
    [self zoomToRect:viewRect page:searchResult.pageIndex animated:YES];
}

@end
