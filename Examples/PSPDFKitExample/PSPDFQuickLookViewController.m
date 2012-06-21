//
//  PSPDFQuickLookViewController.m
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFMagazine.h"
#import "PSPDFQuickLookViewController.h"

@implementation PSPDFQuickLookMagazineContainer

// add QLPreviewItem feature to a category
- (NSURL *)previewItemURL {
    NSURL *previewItemURL = [self.document pathForPage:1];
    return previewItemURL;
}

@end

@implementation PSPDFQuickLookViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super init])) {
        _document = document;
        
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - QLPreviewControllerDataSource

/*!
 * @abstract Returns the number of items that the preview controller should preview.
 * @param controller The Preview Controller.
 * @result The number of items.
 */
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 1; // only supported for whole files
    //return [_document.files count];
}

/*!
 * @abstract Returns the item that the preview controller should preview.
 * @param panel The Preview Controller.
 * @param index The index of the item to preview.
 * @result An item conforming to the QLPreviewItem protocol.
 */
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)cellIndex {
    PSPDFQuickLookMagazineContainer *container = [[PSPDFQuickLookMagazineContainer alloc] init];
    container.document = self.document;
    return container;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - QLPreviewControllerDelegate

- (void)previewControllerWillDismiss:(QLPreviewController *)controller {
    [self dismissModalViewControllerAnimated:YES];
}

@end
