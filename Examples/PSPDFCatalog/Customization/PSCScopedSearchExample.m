//
//  PSCScopedSearchExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"
#import "NSArray+PSCHelper.h"

@interface PSCScopedSearchViewController : PSPDFSearchViewController @end
@interface PSCScopedPDFViewController : PSPDFViewController @end

@interface PSCScopedSearchExample : PSCExample @end
@implementation PSCScopedSearchExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Add scope to PSPDFSearchViewController";
        self.contentDescription = @"Allows more fine-grained search control with a custom scope bar.";
        self.category = PSCExampleCategoryControllerCustomization;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSCScopedPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        [builder overrideClass:PSPDFSearchViewController.class withClass:PSCScopedSearchViewController.class];
    }]];
    return pdfController;
}

@end

@implementation PSCScopedSearchViewController

- (UISearchBar *)createSearchBar {
    UISearchBar *searchBar = [super createSearchBar];
    // Add scopes
    searchBar.scopeButtonTitles = @[@"This page", @"Everything"];
    searchBar.showsScopeBar = YES;
    return searchBar;
}

@end

@implementation PSCScopedPDFViewController

// The PSPDFSearchViewController has its delegate set to the PSPDFViewController, so subclass and add this method.
- (NSIndexSet *)searchViewController:(PSPDFSearchViewController *)searchController searchRangeForScope:(NSString *)scope {
    if ([scope isEqualToString:@"This page"]) {
        return self.visiblePageNumbers.array.psc_indexSet;
    } else {
        return nil; // all pages
    }
}

@end
