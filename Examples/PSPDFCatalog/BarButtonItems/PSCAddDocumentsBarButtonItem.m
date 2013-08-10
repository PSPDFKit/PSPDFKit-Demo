//
//  PSCAddDocumentsBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAddDocumentsBarButtonItem.h"

@implementation PSCAddDocumentsBarButtonItem

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFBarButtonItem

- (UIBarButtonSystemItem)systemItem {
    return UIBarButtonSystemItemAdd;
}

- (NSString *)actionName {
    return PSPDFLocalize(@"Add Documents");
}

// override implementation so that we are *always* enabled.
- (void)updateBarButtonItem {
    self.enabled = YES;
}

- (id)presentAnimated:(BOOL)animated sender:(id)sender {
    PSPDFDocumentPickerController *documentsController = [[PSPDFDocumentPickerController alloc] initWithDirectory:@"/Bundle/Samples" library:PSPDFLibrary.defaultLibrary delegate:self];
    UINavigationController *documentsNavController = [[UINavigationController alloc] initWithRootViewController:documentsController];
    return [self presentModalOrInPopover:documentsNavController sender:sender];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentSelectorControllerDelegate

- (void)documentPickerController:(PSPDFDocumentPickerController *)documentPickerController didSelectDocument:(PSPDFDocument *)document page:(NSUInteger)pageIndex searchString:(NSString *)searchString {
    PSPDFTabbedViewController *tabbedViewController = (PSPDFTabbedViewController *)self.pdfController.parentViewController;

    // add new document, and set as current
    [tabbedViewController addDocuments:@[document] atIndex:NSUIntegerMax animated:YES];
    tabbedViewController.visibleDocument = document;
    tabbedViewController.pdfController.page = pageIndex;

    if (searchString && documentPickerController.fullTextSearchEnabled) {
        [tabbedViewController.pdfController searchForString:searchString options:@{PSPDFViewControllerSearchHeadlessKey : @YES} animated:YES];
    }

    // hide controller
    if (PSIsIpad())[self.class dismissPopoverAnimated:YES completion:NULL];
    else [documentPickerController dismissViewControllerAnimated:YES completion:NULL];
}

@end
