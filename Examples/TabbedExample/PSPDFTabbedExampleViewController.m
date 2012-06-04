//
//  PSPDFTabbedExampleViewController.m
//  TabbedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFTabbedExampleViewController.h"
#import "PSPDFAddDocumentsBarButtonItem.h"

@implementation PSPDFTabbedExampleViewController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithPDFViewController:(PSPDFViewController *)pdfViewController {
    if ((self = [super initWithPDFViewController:pdfViewController])) {
        
        // enable automatic peristance and restore the last state
        self.enableAutomaticStatePersistance = YES;

        // on iPhone, we want a backButton here.
        if (PSIsIpad()) {
            PSPDFAddDocumentsBarButtonItem *addDocumentsButton = [[PSPDFAddDocumentsBarButtonItem alloc] initWithPDFViewController:self.pdfViewController];
            self.pdfViewController.leftBarButtonItems = [NSArray arrayWithObject:addDocumentsButton];
        }
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFTabbedViewControllerDelegate

- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController willChangeDocuments:(NSArray *)newDocuments {
    NSLog(@"willChangeDocuments: %@", newDocuments);
    
    // return YES to allow the change
    return YES;
}

- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeDocuments:(NSArray *)oldDocuments {
    NSLog(@"didChangeDocuments: %@ (old)", oldDocuments);
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
