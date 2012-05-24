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

#define kPSPDFTabbedDocumentsPersistKey @"kPSPDFTabbedDocumentsPersistKey"

- (void)restoreState {
    NSData *archiveData = [[NSUserDefaults standardUserDefaults] objectForKey:kPSPDFTabbedDocumentsPersistKey];
    NSDictionary *persistDict = nil;
    if (archiveData) {
        NSLog(@"restoring state.");
        @try {
            // This method raises an NSInvalidArchiveOperationException if data is not a valid archive.
            persistDict = [NSKeyedUnarchiver unarchiveObjectWithData:archiveData];
        }
        @catch (NSException *exception) {
            NSLog(@"Failed to restore persist state: %@", exception);
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPSPDFTabbedDocumentsPersistKey];
        }
    }
    if (persistDict) {
        self.documents = [persistDict objectForKey:NSStringFromSelector(@selector(documents))];
        self.visibleDocument = [persistDict objectForKey:NSStringFromSelector(@selector(visibleDocument))];
    }
}

- (void)persistState {
    NSLog(@"persisting state.");
    NSMutableDictionary *persistDict = [NSMutableDictionary dictionaryWithCapacity:2];
    if (self.documents) {
        [persistDict setObject:self.documents forKey:NSStringFromSelector(@selector(documents))];
    }
    if (self.visibleDocument) {
        [persistDict setObject:self.visibleDocument forKey:NSStringFromSelector(@selector(visibleDocument))];
    }
    NSData *archive = [NSKeyedArchiver archivedDataWithRootObject:persistDict];
    [[NSUserDefaults standardUserDefaults] setObject:archive forKey:kPSPDFTabbedDocumentsPersistKey];
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
