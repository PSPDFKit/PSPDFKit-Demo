//
//  PSCTabbedExampleViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCTabbedExampleViewController.h"
#import "PSCAddDocumentsBarButtonItem.h"
#import "PSCClearTabsButtonItem.h"

@implementation PSCTabbedExampleViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)initWithPDFViewController:(PSPDFMultiDocumentPDFViewController *)pdfController {
    if ((self = [super initWithPDFViewController:pdfController])) {
        self.delegate = self;

        // change status bar setting
        [pdfController updateConfigurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
            builder.shouldHideStatusBarWithHUD = YES;
        }];

        self.navigationItem.leftItemsSupplementBackButton = YES;

        // enable automatic persistance and restore the last state
        self.enableAutomaticStatePersistence = YES;

        // on iPhone, we want a backButton here.
        PSCClearTabsButtonItem *clearTabsButton = [[PSCClearTabsButtonItem alloc] initWithPDFViewController:self.pdfController];
        self.pdfController.barButtonItemsAlwaysEnabled = @[clearTabsButton];
        if (PSCIsIPad()) {
            PSCAddDocumentsBarButtonItem *addDocumentsButton = [[PSCAddDocumentsBarButtonItem alloc] initWithPDFViewController:self.pdfController];
            self.pdfController.leftBarButtonItems = @[addDocumentsButton, clearTabsButton];
        } else {
            self.pdfController.leftBarButtonItems = @[clearTabsButton];
            self.pdfController.rightBarButtonItems = @[self.pdfController.annotationButtonItem, self.pdfController.outlineButtonItem, self.pdfController.activityButtonItem, self.pdfController.viewModeButtonItem];
            self.pdfController.activityButtonItem.applicationActivities = @[PSPDFActivityTypeSearch, PSPDFActivityTypeOpenIn, PSPDFActivityTypeBookmarks];
            self.navigationItem.leftItemsSupplementBackButton = YES;
        }

        // choose *some* documents randomly if state could not be restored.
        if (![self restoreState] || self.documents.count == 0) {
            NSArray *documents = [PSPDFDocumentPickerController documentsFromDirectory:@"/Bundle/Samples" includeSubdirectories:YES];
            documents = [documents filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                return arc4random_uniform(2) > 0; // returns 0 or 1 randomly.
            }]];
            self.documents = [documents subarrayWithRange:NSMakeRange(0, MIN((NSUInteger)5, documents.count))];
        }
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFTabbedViewControllerDelegate

- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController shouldChangeDocuments:(NSArray *)newDocuments {
    //NSLog(@"shouldChangeDocuments: %@", newDocuments);

    // return YES to allow the change
    return YES;
}

- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeDocuments:(NSArray *)oldDocuments {
    //NSLog(@"didChangeDocuments: %@ (old)", oldDocuments);
}

- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController shouldChangeVisibleDocument:(PSPDFDocument *)newDocument {
    //NSLog(@"shouldChangeVisibleDocument: %@", newDocument);

    // return YES to allow the change
    return YES;
}

- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeVisibleDocument:(PSPDFDocument *)oldDocument {
    //NSLog(@"didChangeVisibleDocument: %@ (old)", oldDocument);
}

@end
