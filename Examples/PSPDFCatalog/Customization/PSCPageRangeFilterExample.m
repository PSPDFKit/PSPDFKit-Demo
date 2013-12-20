//
//  PSCPageRangeFilter.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCPageRangeFilterExample.h"
#import "UIBarButtonItem+PSCBlockSupport.h"
#import "PSCAssetLoader.h"

@implementation PSCPageRangeFilterExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Add pageRange filter for bookmarked pages";
        self.category = PSCExampleCategoryPageRange;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
    
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
        
        // After setting pageRange, we need to clear the cache and reload the controller
        [PSPDFCache.sharedCache removeCacheForDocument:document deleteDocument:NO error:NULL];
        [weakController reloadData];
        
        // (Example-Global) Cache needs to be cleared since pages will change.
        //TODO: fix me
        //_clearCacheNeeded = YES;
    }];
    
    controller.rightBarButtonItems = @[filterBarButton, controller.bookmarkButtonItem, controller.outlineButtonItem, controller.annotationButtonItem, controller.viewModeButtonItem];
    controller.barButtonItemsAlwaysEnabled = @[filterBarButton];
    controller.thumbnailBarMode = PSPDFThumbnailBarModeScrollable;
    controller.renderingMode = PSPDFPageRenderingModeFullPageBlocking;
    return controller;
}

@end
