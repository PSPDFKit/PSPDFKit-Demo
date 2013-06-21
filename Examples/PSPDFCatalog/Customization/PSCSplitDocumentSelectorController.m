//
//  PSCSplitDocumentSelectorController.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCSplitDocumentSelectorController.h"
#import "PSCSplitPDFViewController.h"
#import "PSCAppDelegate.h"

@implementation PSCSplitDocumentSelectorController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super initWithDirectory:@"/Bundle/Samples" library:PSPDFLibrary.defaultLibrary delegate:self])) {
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
    UIWindow *window = self.view.window;
    // ensure popover is dismissed or we'll crash
    [self.masterVC.masterPopoverController dismissPopoverAnimated:NO];
    window.rootViewController = ((PSCAppDelegate *)UIApplication.sharedApplication.delegate).catalog;
}

// tests fast cycling through the pdf elements
- (void)cycleAction {
    [[PSPDFCache sharedCache] clearCache];

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
    [self.masterVC displayDocument:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentSelectorControllerDelegate

- (void)documentSelectorController:(PSPDFDocumentSelectorController *)controller didSelectDocument:(PSPDFDocument *)document {
#if defined(kPSPDFEnableDocumentStressTest) && kPSPDFEnableDocumentStressTest
    // Copy is purely there as a stress test.
    document = [document copy];
#endif

    PSCSplitPDFViewController *masterVC = self.masterVC;
    [masterVC displayDocument:document];

    // hide controller
    [masterVC.popoverController dismissPopoverAnimated:YES];
}

@end
