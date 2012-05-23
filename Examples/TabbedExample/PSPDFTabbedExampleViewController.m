//
//  PSPDFTabbedExampleViewController.m
//  TabbedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFTabbedExampleViewController.h"

@implementation PSPDFTabbedExampleViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocuments:(NSArray *)documents pdfViewController:(PSPDFViewController *)pdfViewController {
    if ((self = [super initWithDocuments:documents pdfViewController:pdfViewController])) {
        self.pdfViewController.pageCurlEnabled = YES;
        self.pdfViewController.toolbarBackButton = nil;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFTabbedViewControllerDelegate

- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController willChangeDocumentSet:(NSArray *)newDocuments {
    NSLog(@"willChangeDocumentSet: %@", newDocuments);
    
    // return YES to allow the change
    return YES;
}

- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeDocumentSet:(NSArray *)oldDocuments {
    NSLog(@"didChangeDocumentSet: %@ (old)", oldDocuments);
}

- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController willChangeVisibleDocument:(PSPDFDocument *)newDocument {
    NSLog(@"willChangeVisibleDocument: %@", newDocument);

    // return YES to allow the change
    return YES;
}

- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeVisibleDocument:(PSPDFDocument *)oldDocument {
    NSLog(@"didChangeVisibleDocument: %@ (old)", oldDocument);   
}

@end
