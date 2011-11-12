//
//  PSPDFQuickLookViewController.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/26/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFMagazine.h"
#import "PSPDFQuickLookViewController.h"

@implementation PSPDFQuickLookMagazineContainer
@synthesize document = document_;

// add QLPreviewItem feature to a category
- (NSURL *)previewItemURL {
    NSURL *previewItemURL = [self.document pathForPage:1];
    return previewItemURL;
}

@end

@implementation PSPDFQuickLookViewController

@synthesize document = document_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super init])) {
        document_ = document;
        
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
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller; {
    return 1; // only supported for whole files
    //return [document_.files count];
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

- (void)previewControllerWillDismiss:(QLPreviewController *)controller; {
    [self dismissModalViewControllerAnimated:YES];
}

@end
