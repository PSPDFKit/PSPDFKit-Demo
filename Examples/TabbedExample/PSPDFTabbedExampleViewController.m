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
#pragma mark - Private

#define kPSPDFTabbedDocumentsKey @"kPSPDFTabbedDocumentsKey"
#define kPSPDFTabbedVisibleDocumentKey @"kPSPDFTabbedVisibleDocumentKey"

- (void)restoreState {
    NSLog(@"restoring state");

    self.documents = [[NSUserDefaults standardUserDefaults] objectForKey:kPSPDFTabbedDocumentsKey];
    self.visibleDocument = [[NSUserDefaults standardUserDefaults] objectForKey:kPSPDFTabbedVisibleDocumentKey];
}

- (void)persistState {
    NSLog(@"persisting state");

    [[NSUserDefaults standardUserDefaults] setObject:self.documents forKey:kPSPDFTabbedDocumentsKey];
    [[NSUserDefaults standardUserDefaults] setObject:self.visibleDocument forKey:kPSPDFTabbedVisibleDocumentKey];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocuments:(NSArray *)documents pdfViewController:(PSPDFViewController *)pdfViewController {
    if ((self = [super initWithDocuments:documents pdfViewController:pdfViewController])) {
        self.pdfViewController.pageCurlEnabled = YES;
        [self restoreState];

        PSPDFAddDocumentsBarButtonItem *addDocumentsButton = [[PSPDFAddDocumentsBarButtonItem alloc] initWithPDFViewController:self.pdfViewController];
        self.pdfViewController.leftBarButtonItems = [NSArray arrayWithObject:addDocumentsButton];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistState) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(persistState) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [self persistState];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
