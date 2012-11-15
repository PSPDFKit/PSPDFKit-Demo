//
//  PSCRotatablePDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCRotatablePDFViewController.h"

@implementation PSCRotatablePDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];

    // prevents page flashing when there's cached content available at the cost of slight main thread blocking.
    self.renderingMode = PSPDFPageRenderingModeFullPageBlocking;

    UIBarButtonItem *rotate = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(rotateAction:)];
    self.leftBarButtonItems = @[rotate];
    self.navigationItem.leftItemsSupplementBackButton = YES;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)rotateAction:(id)sender {
    // we need to invalidate the cache
    [[PSPDFCache sharedCache] removeCacheForDocument:self.document deleteDocument:NO error:NULL];

    // rotate 90 degree counter-clock-wise (and make sure we don't set something >= 360)
    BOOL rotateAll = YES;
    if (rotateAll) {
        for (NSUInteger pageIndex=0; pageIndex < [self.document pageCount]; pageIndex++) {
            PSPDFPageInfo *pageInfo = [self.document pageInfoForPage:pageIndex];
            pageInfo.pageRotation = PSPDFNormalizeRotation(pageInfo.pageRotation - 90);
        }
    }else {
        PSPDFPageInfo *pageInfo = [self.document pageInfoForPage:self.page];
        pageInfo.pageRotation = PSPDFNormalizeRotation(pageInfo.pageRotation - 90);
    }
    // request an immediate rendering of the current page, will block the main thread but prevent flashing.
    [[PSPDFCache sharedCache] renderAndCacheImageForDocument:self.document page:self.page size:PSPDFSizeNative error:NULL];

    // reload the controller
    [self reloadData];
}

@end
