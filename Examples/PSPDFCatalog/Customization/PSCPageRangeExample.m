//
//  PSCPageRangeExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCPageRangeExample.h"
#import "PSCAssetLoader.h"

@implementation PSCPageRangeExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Limit pages to 5-10 via pageRange";
        self.category = PSCExampleCategoryPageRange;
    }
    return self;
}

- (UIViewController *)invoke {
    // cache needs to be cleared since pages will change.
    [[PSPDFCache sharedCache] clearCache];
    // TODO: fix me
    //_clearCacheNeeded = YES;
    
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.pageRange = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4, 5)];
    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
    controller.rightBarButtonItems = @[controller.annotationButtonItem, controller.viewModeButtonItem];
    controller.thumbnailBarMode = PSPDFThumbnailBarModeScrollable;
    return controller;
}

@end

