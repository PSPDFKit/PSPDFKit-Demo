//
//  PSCAnnotationTableBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCAnnotationTableBarButtonItem.h"
#import "PSCAnnotationTableViewController.h"

@implementation PSCAnnotationTableBarButtonItem

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFBarButtonItem

- (UIBarButtonSystemItem)systemItem {
    return UIBarButtonSystemItemBookmarks;
}

- (NSString *)actionName {
    return PSPDFLocalize(@"List Annotations");
}

- (id)presentAnimated:(BOOL)animated sender:(PSPDFBarButtonItem *)sender {
    PSCAnnotationTableViewController *annotationList = [[PSCAnnotationTableViewController alloc] initWithPDFViewController:self.pdfController];
    UINavigationController *documentsNavController = [[UINavigationController alloc] initWithRootViewController:annotationList];
    return [self presentModalOrInPopover:documentsNavController sender:sender];
}

@end
