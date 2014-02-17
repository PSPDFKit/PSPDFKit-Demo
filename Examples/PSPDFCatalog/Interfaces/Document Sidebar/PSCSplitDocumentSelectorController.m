//
//  PSCSplitDocumentSelectorController.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSplitDocumentSelectorController.h"
#import "PSCSplitPDFViewController.h"
#import "PSCAppDelegate.h"

@implementation PSCSplitDocumentSelectorController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super initWithDirectory:@"/Bundle/Samples" includeSubdirectories:YES library:PSPDFLibrary.defaultLibrary delegate:self])) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.f, 600.f);

        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStyleBordered target:self action:@selector(backToCatalog)];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cycle", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cycleAction)];

        self.navigationItem.leftBarButtonItems = @[backBarButtonItem, [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Deselect", @"") style:UIBarButtonItemStylePlain target:self action:@selector(deselectAction)]];

    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)backToCatalog {
    [self.parentViewController dismissViewControllerAnimated:YES completion:NULL];
}

// tests fast cycling through the pdf elements
- (void)cycleAction {
    [PSPDFCache.sharedCache clearCache];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (NSUInteger sectionIndex = 0; sectionIndex < [self numberOfSectionsInTableView:self.tableView]; sectionIndex++) {
            for (NSUInteger rowIndex = 0; rowIndex < [self tableView:self.tableView numberOfRowsInSection:sectionIndex]; rowIndex++) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                    [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];
                });
                [NSThread sleepForTimeInterval:0.05 * arc4random_uniform(5)];
            }
        }
    });
}

- (void)deselectAction {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    [self.masterVC displayDocument:nil page:0];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentSelectorControllerDelegate

- (void)documentPickerController:(PSPDFDocumentPickerController *)controller didSelectDocument:(PSPDFDocument *)document page:(NSUInteger)pageIndex searchString:(NSString *)searchString {
#if defined(PSCEnableDocumentStressTest) && PSCEnableDocumentStressTest
    // Copy is purely there as a stress test.
    document = [document copy];
#endif

    PSCSplitPDFViewController *masterVC = self.masterVC;
    [masterVC displayDocument:document page:pageIndex];

    // hide controller
    [masterVC.popoverController dismissPopoverAnimated:YES];
}

@end
