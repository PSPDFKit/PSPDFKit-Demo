//
//  PSCCustomBookmarkImageExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCCustomBookmarkImageExample.h"
#import "PSCAssetLoader.h"

@interface PSCCustomBookmarkBarButtonItem : PSPDFBookmarkBarButtonItem
@end

@implementation PSCCustomBookmarkImageExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Custom toolbar icon for bookmark item";
        self.contentDescription = @"Simple example that will replace the bookmark icon image with a trash can";
        self.category = PSCExampleCategoryBarButtons;
        self.priority = 110;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.title = self.title;
    [pdfController overrideClass:PSPDFBookmarkBarButtonItem.class withClass:PSCCustomBookmarkBarButtonItem.class];
    pdfController.bookmarkButtonItem.tapChangesBookmarkStatus = NO;
    pdfController.rightBarButtonItems = @[pdfController.bookmarkButtonItem, pdfController.viewModeButtonItem];
    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomBookmarkBarButtonItem

// Simple subclass, replacing the image.
@implementation PSCCustomBookmarkBarButtonItem

// We are lazy and use a systemItem for the example.
- (UIBarButtonSystemItem)systemItem {
    BOOL hasBookmark = [self bookmarkNumberForVisiblePages] != nil;
    return hasBookmark ? UIBarButtonSystemItemBookmarks : UIBarButtonSystemItemTrash;
}

// Image has priority, so nil that out.
- (UIImage *)image {
    return nil;
}

@end
