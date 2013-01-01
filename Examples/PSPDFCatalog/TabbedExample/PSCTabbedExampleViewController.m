//
//  PSCTabbedExampleViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCTabbedExampleViewController.h"
#import "PSCAddDocumentsBarButtonItem.h"
#import "PSCClearTabsButtonItem.h"
#import <objc/runtime.h>

@implementation PSCTabbedExampleViewController

const char *clearAllActionSheetToken;

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithPDFViewController:(PSPDFViewController *)pdfViewController {
    if ((self = [super initWithPDFViewController:pdfViewController])) {

        // change status bar setting
        //self.pdfViewController.statusBarStyleSetting = PSPDFStatusBarSmartBlack;

        self.navigationItem.leftItemsSupplementBackButton = YES;

        // enable automatic peristance and restore the last state
        self.enableAutomaticStatePersistance = YES;

        // on iPhone, we want a backButton here.
        PSCClearTabsButtonItem *clearTabsButton = [[PSCClearTabsButtonItem alloc] initWithPDFViewController:self.pdfController];
        if (PSIsIpad()) {
            PSCAddDocumentsBarButtonItem *addDocumentsButton = [[PSCAddDocumentsBarButtonItem alloc] initWithPDFViewController:self.pdfController];
            self.pdfController.leftBarButtonItems = @[addDocumentsButton, clearTabsButton];
        }else {
            self.pdfController.leftBarButtonItems = @[clearTabsButton];
            self.navigationItem.leftItemsSupplementBackButton = YES;
        }

        // choose *some* documents randomly if state could not be restored.
        if (![self restoreState] || [self.documents count] == 0) {
            NSArray *documents = [PSCDocumentSelectorController documentsFromDirectory:@"/Bundle/Samples"];
            self.documents = [documents filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return arc4random_uniform(2) > 0; // returns 0 or 1 randomly.
            }]];
        }
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFTabbedViewControllerDelegate

- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController shouldChangeDocuments:(NSArray *)newDocuments {
    NSLog(@"shouldChangeDocuments: %@", newDocuments);

    // return YES to allow the change
    return YES;
}

- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeDocuments:(NSArray *)oldDocuments {
    NSLog(@"didChangeDocuments: %@ (old)", oldDocuments);
}

- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController shouldChangeVisibleDocument:(PSPDFDocument *)newDocument {
    NSLog(@"shouldChangeVisibleDocument: %@", newDocument);

    // return YES to allow the change
    return YES;
}

- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeVisibleDocument:(PSPDFDocument *)oldDocument {
    NSLog(@"didChangeVisibleDocument: %@ (old)", oldDocument);
}

@end
