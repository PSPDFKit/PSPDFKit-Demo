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
#import "PSPDFActivityViewController.h"
#import "PSTAlertController.h"

@interface PSCTabbedExampleViewController () <PSPDFDocumentPickerControllerDelegate>
@property (nonatomic, strong) UIBarButtonItem *clearTabsButtonItem;
@end

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
        _clearTabsButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearTabsButtonPressed:)];
        self.pdfController.barButtonItemsAlwaysEnabled = @[_clearTabsButtonItem];
        if (PSCIsIPad()) {
            UIBarButtonItem *addDocumentsButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDocumensButtonPressed:)];
            addDocumentsButton.accessibilityLabel = PSPDFLocalize(@"Add Documents");

            self.pdfController.leftBarButtonItems = @[addDocumentsButton, _clearTabsButtonItem];
        } else {
            self.pdfController.leftBarButtonItems = @[_clearTabsButtonItem];
            self.pdfController.rightBarButtonItems = @[self.pdfController.annotationButtonItem, self.pdfController.outlineButtonItem, self.pdfController.activityButtonItem, self.pdfController.viewModeButtonItem];
            self.pdfController.applicationActivities = @[PSPDFActivityTypeSearch, PSPDFActivityTypeOpenIn, PSPDFActivityTypeBookmarks];
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
#pragma mark - Private

- (void)addDocumensButtonPressed:(id)sender {
    PSPDFDocumentPickerController *documentsController = [[PSPDFDocumentPickerController alloc] initWithDirectory:@"/Bundle/Samples" includeSubdirectories:YES library:PSPDFKit.sharedInstance.library delegate:self];
    [self.pdfController presentViewController:documentsController options:@{PSPDFPresentationInNavigationControllerKey: @YES} animated:YES sender:sender error:NULL completion:NULL];
}

- (void)clearTabsButtonPressed:(id)sender {
    PSTAlertController *sheetController = [PSTAlertController actionSheetWithTitle:nil];
    [sheetController addCancelActionWithHandler:nil];

    __weak typeof (self) weakSelf = self;
    [sheetController addAction:[PSTAlertAction actionWithTitle:@"Close all tabs" style:PSTAlertActionStyleDestructive handler:^(PSTAlertAction *action) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf removeDocuments:strongSelf.documents animated:YES];
    }]];
    [sheetController showWithSender:sender controller:self animated:YES completion:nil];
}

- (void)updateToolbarItems {
    self.clearTabsButtonItem.enabled = self.documents.count > 0;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentPickerControllerDelegate

- (void)documentPickerController:(PSPDFDocumentPickerController *)documentPickerController didSelectDocument:(PSPDFDocument *)document page:(NSUInteger)pageIndex searchString:(NSString *)searchString {

    // add new document, and set as current
    [self addDocuments:@[document] atIndex:NSUIntegerMax animated:YES];
    self.visibleDocument = document;
    self.pdfController.page = pageIndex;

    if (searchString && documentPickerController.fullTextSearchEnabled) {
        [self.pdfController searchForString:searchString options:@{PSPDFViewControllerSearchHeadlessKey: @YES} sender:nil animated:YES];
    }

    // Hide controller.
    [self.pdfController dismissViewControllerAnimated:YES class:documentPickerController.class completion:NULL];
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
    [self updateToolbarItems];
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
