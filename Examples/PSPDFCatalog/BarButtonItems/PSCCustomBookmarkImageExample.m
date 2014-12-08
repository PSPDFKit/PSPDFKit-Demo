//
//  PSCCustomBookmarkImageExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCCustomBookmarkImageExample : PSCExample @end
@interface PSCCustomBookmarkBarButtonItem : PSPDFBookmarkBarButtonItem @end

@implementation PSCCustomBookmarkImageExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Custom toolbar icon for bookmark item";
        self.contentDescription = @"Simple example that will replace the bookmark icon image with a trash can";
        self.category = PSCExampleCategoryBarButtons;
        self.priority = 110;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        [builder overrideClass:PSPDFBookmarkBarButtonItem.class withClass:PSCCustomBookmarkBarButtonItem.class];
    }]];
    pdfController.title = self.title;
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
