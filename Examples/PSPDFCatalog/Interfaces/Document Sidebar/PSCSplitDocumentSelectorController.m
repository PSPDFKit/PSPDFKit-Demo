//
//  PSCSplitDocumentSelectorController.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSplitDocumentSelectorController.h"
#import "PSCSplitPDFViewController.h"

@implementation PSCSplitDocumentSelectorController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)init {
    if ((self = [super initWithDirectory:@"/Bundle/Samples" includeSubdirectories:YES library:PSPDFKit.sharedInstance.library delegate:self])) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.f, 600.f);

        UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStyleBordered target:self action:@selector(backToCatalog)];

        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cycle", @"") style:UIBarButtonItemStylePlain target:self action:@selector(cycleAction)];

        self.navigationItem.leftBarButtonItems = @[backBarButtonItem, [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Deselect", @"") style:UIBarButtonItemStylePlain target:self action:@selector(deselectAction)]];

    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)backToCatalog {
    PSCSplitPDFViewController *masterController = self.masterController;
    [masterController dismissViewControllerAnimated:YES completion:NULL];
    [masterController.masterPopoverController dismissPopoverAnimated:YES];
}

// tests fast cycling through the pdf elements
- (void)cycleAction {
    [PSPDFKit.sharedInstance.cache clearCache];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        for (NSInteger sectionIndex = 0; sectionIndex < [self numberOfSectionsInTableView:self.tableView]; sectionIndex++) {
            for (NSInteger rowIndex = 0; rowIndex < [self tableView:self.tableView numberOfRowsInSection:sectionIndex]; rowIndex++) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
                    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
                    [self tableView:self.tableView didSelectRowAtIndexPath:selectedIndexPath];
                });
                [NSThread sleepForTimeInterval:0.05f * arc4random_uniform(5)];
            }
        }
    });
}

- (void)deselectAction {
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
    [self.masterController displayDocument:nil page:0];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentSelectorControllerDelegate

- (void)documentPickerController:(PSPDFDocumentPickerController *)controller didSelectDocument:(PSPDFDocument *)document page:(NSUInteger)pageIndex searchString:(NSString *)searchString {
#if defined(PSCEnableDocumentStressTest) && PSCEnableDocumentStressTest
    // Copy is purely there as a stress test.
    document = [document copy];
#endif

    PSCSplitPDFViewController *masterVC = self.masterController;
    [masterVC displayDocument:document page:pageIndex];

    // hide controller
    [masterVC.popoverController dismissPopoverAnimated:YES];
}

@end
