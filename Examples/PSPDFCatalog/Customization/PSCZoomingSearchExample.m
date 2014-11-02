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

@property (nonatomic, assign, getter=isInitialSearchAlreadyPerformed) BOOL initialSearchAlreadyPerformed;

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
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    PSPDFViewController *pdfController = [[PSCZoomingSearchPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end

@implementation PSCZoomingSearchPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    // Automatically start searching for the first time this view is displayed.
    if (!self.isInitialSearchAlreadyPerformed) {
        [self searchForString:@"Tomat" options:nil sender:nil animated:YES];
        self.initialSearchAlreadyPerformed = YES;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFSearchViewControllerDelegate

- (void)searchViewController:(PSPDFSearchViewController *)searchController didTapSearchResult:(PSPDFSearchResult *)searchResult {
    [super searchViewController:searchController didTapSearchResult:searchResult];

    [self zoomToSearchResult:searchResult];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFInlineSearchManagerDelegate

- (void)inlineSearchManager:(PSPDFInlineSearchManager *)manager didFocusSearchResult:(PSPDFSearchResult *)searchResult {
    [super inlineSearchManager:manager didFocusSearchResult:searchResult];

    [self zoomToSearchResult:searchResult];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)zoomToSearchResult:(PSPDFSearchResult *)searchResult {
    CGRect viewRect = [[self pageViewForPage:searchResult.pageIndex] convertPDFRectToViewRect:searchResult.selection.frame];
    //    viewRect = CGRectInset(viewRect, 20.f, 20.f); // leave some space
    [self zoomToRect:viewRect page:searchResult.pageIndex animated:YES];
}

@end
