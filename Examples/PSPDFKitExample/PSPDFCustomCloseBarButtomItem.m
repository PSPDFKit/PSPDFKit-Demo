//
//  PSPDFCustomCloseBarButtomItem.m
//  PSPDFKitExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFCustomCloseBarButtomItem.h"

@implementation PSPDFCustomCloseBarButtomItem

- (NSString *)actionName {
    return PSIsIpad() ? PSPDFLocalize(@"Documents") : PSPDFLocalize(@"Back");
}

- (void)action:(PSPDFBarButtonItem *)sender {
    [self.pdfViewController.navigationController popViewControllerAnimated:NO];
}

@end
