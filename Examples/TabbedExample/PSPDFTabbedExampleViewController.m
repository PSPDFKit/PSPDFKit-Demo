//
//  PSPDFTabbedExampleViewController.m
//  TabbedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFTabbedExampleViewController.h"
#import "PSPDFAddDocumentsBarButtonItem.h"
#import <objc/runtime.h>

@implementation PSPDFTabbedExampleViewController

const char *clearAllActionSheetToken;

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)clearAll:(id)sender {
    // ensure we correctly shwow/hide the sheet
    PSPDFActionSheet *actionSheet = objc_getAssociatedObject(sender, clearAllActionSheetToken);
    if (actionSheet) {
        [actionSheet dismissWithClickedButtonIndex:-1 animated:YES];
    }else {
        actionSheet = [[PSPDFActionSheet alloc] initWithTitle:nil];
        [actionSheet setDestructiveButtonWithTitle:PSPDFLocalize(@"Clear All Tabs") block:^{
            [self removeDocuments:self.documents animated:YES];
        }];
        [actionSheet setCancelButtonWithTitle:PSPDFLocalize(@"Cancel") block:NULL];
        actionSheet.destroyBlock = ^{
            objc_removeAssociatedObjects(sender);
        };
        objc_setAssociatedObject(sender, clearAllActionSheetToken, actionSheet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        if (PSIsIpad()) {
            [actionSheet showFromBarButtonItem:sender animated:YES];
        }else {
            [actionSheet showInView:self.view];
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithPDFViewController:(PSPDFViewController *)pdfViewController {
    if ((self = [super initWithPDFViewController:pdfViewController])) {
        
        // enable automatic peristance and restore the last state
        self.enableAutomaticStatePersistance = YES;
        
        // on iPhone, we want a backButton here.
        UIBarButtonItem *clearAllButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearAll:)];
        if (PSIsIpad()) {
            PSPDFAddDocumentsBarButtonItem *addDocumentsButton = [[PSPDFAddDocumentsBarButtonItem alloc] initWithPDFViewController:self.pdfViewController];
            self.pdfViewController.leftBarButtonItems = [NSArray arrayWithObjects:addDocumentsButton, clearAllButton, nil];
        }else {
            self.pdfViewController.leftBarButtonItems = [NSArray arrayWithObject:clearAllButton];
            self.navigationItem.leftItemsSupplementBackButton = YES;
        }

        // iOS6B3 has a strange bug where the backButton is not clockable (has a width of 0)
        PSPDF_IF_IOS6_OR_GREATER(NSMutableArray *leftBarButtonItems = [NSMutableArray arrayWithArray:self.pdfViewController.leftBarButtonItems];
                                 [leftBarButtonItems insertObject:self.pdfViewController.closeButtonItem atIndex:0];
                                 self.pdfViewController.leftBarButtonItems = leftBarButtonItems;
                                 self.navigationItem.leftItemsSupplementBackButton = NO;
                                 )
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

- (BOOL)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController willChangeVisibleDocument:(PSPDFDocument *)newDocument {
    NSLog(@"willChangeVisibleDocument: %@", newDocument);
    
    // return YES to allow the change
    return YES;
}

- (void)tabbedPDFController:(PSPDFTabbedViewController *)tabbedPDFController didChangeVisibleDocument:(PSPDFDocument *)oldDocument {
    NSLog(@"didChangeVisibleDocument: %@ (old)", oldDocument);   
}

@end
