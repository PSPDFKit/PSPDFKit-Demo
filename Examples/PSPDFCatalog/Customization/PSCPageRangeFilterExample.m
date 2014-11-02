//
//  PSCPageRangeFilter.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "UIBarButtonItem+PSCBlockSupport.h"
#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCPageRangeFilterExample : PSCExample @end
@implementation PSCPageRangeFilterExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Add pageRange filter for bookmarked pages";
        self.contentDescription = @"Adds a toggleable button to the toolbar that allows to filter the document for bookmarked pages only.";
        self.category = PSCExampleCategoryPageRange;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    document.UID = NSStringFromClass(PSCPageRangeFilterExample.class);
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        builder.thumbnailBarMode = PSPDFThumbnailBarModeScrollable;
        builder.renderingMode = PSPDFPageRenderingModeFullPageBlocking;
    }]];

    // Create the filter barButton
    __weak PSPDFViewController *weakController = controller;
    __block UIBarButtonItem *filterBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered block:^(id sender) {

        // Before setting anything, save.
        [document saveAnnotationsWithError:NULL];

        // Update pageRange-filter
        BOOL isFilterSet = document.pageRange != nil;
        filterBarButton.title = isFilterSet ? @"Filter" : @"Disable Filter";
        NSMutableIndexSet *set = nil;
        if (!isFilterSet) {
            set = [NSMutableIndexSet indexSet];
            for (PSPDFBookmark *bookmark in document.bookmarks) [set addIndex:bookmark.page];
        }
        document.pageRange = set;

        // After setting pageRange, we need to clear the cache and reload the controller.
        [PSPDFKit.sharedInstance.cache removeCacheForDocument:document deleteDocument:NO error:NULL];
        [weakController reloadData];
    }];

    controller.rightBarButtonItems = @[filterBarButton, controller.bookmarkButtonItem, controller.outlineButtonItem, controller.annotationButtonItem, controller.viewModeButtonItem];
    controller.barButtonItemsAlwaysEnabled = @[filterBarButton];
    return controller;
}

@end
