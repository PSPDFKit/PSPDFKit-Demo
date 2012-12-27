//
//  PSCGoToPageButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCGoToPageButtonItem.h"
#import <objc/runtime.h>

@interface PSCGoToPageButtonItem() <UITextFieldDelegate>
@end

@implementation PSCGoToPageButtonItem

const char kPSCAlertViewKey;

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFBarButtonItem

- (id)initWithPDFViewController:(PSPDFViewController *)pdfViewController {
    if ((self = [super initWithPDFViewController:pdfViewController])) {
        _enablePartialLabelMatching = YES;
    }
    return self;
}

- (UIBarButtonSystemItem)systemItem {
    return UIBarButtonSystemItemBookmarks;
}

- (NSString *)actionName {
    return PSPDFLocalize(@"Go to page...");
}

- (void)action:(PSPDFBarButtonItem *)sender {
    [[self class] dismissPopoverAnimated:YES];

    PSPDFAlertView *websitePrompt = [[PSPDFAlertView alloc] initWithTitle:PSPDFLocalize(@"Go to Page") message:nil];
    websitePrompt.tintColor = [self.pdfController alertViewTintColor];
    websitePrompt.alertViewStyle = UIAlertViewStylePlainTextInput;

    [websitePrompt setCancelButtonWithTitle:PSPDFLocalize(@"Cancel") block:nil];
    [websitePrompt addButtonWithTitle:PSPDFLocalize(@"Go to") extendedBlock:^(PSPDFAlertView *alert, NSInteger buttonIndex) {

        NSString *pageLabel = [alert textFieldAtIndex:0].text ?: @"";
        NSUInteger pageIndex = [self.pdfController.document pageForPageLabel:pageLabel partialMatching:self.enablePartialLabelMatching];

        // if input is just numeric, convert to page
        if (pageIndex == NSNotFound) {
            if ([pageLabel length] > 0 && [pageLabel rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].length == 0) {
                pageIndex = [pageLabel integerValue];
                if (pageIndex == 0) pageIndex = NSNotFound; // 0 is invalid!
                else pageIndex--; // convert from user-page (starts at 1) to system (starts at 0)
            }
        }

        if (pageIndex == NSNotFound) {
            [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:PSPDFLocalize(@"Page %@ not found"), pageLabel] message:nil delegate:nil cancelButtonTitle:PSPDFLocalize(@"Ok") otherButtonTitles:nil] show];
        }else {
            [self.pdfController setViewMode:PSPDFViewModeDocument animated:YES];
            [self.pdfController setPage:pageIndex animated:YES];
        }
    }];

    [[websitePrompt textFieldAtIndex:0] setDelegate:self]; // enable return key
    objc_setAssociatedObject([websitePrompt textFieldAtIndex:0], &kPSCAlertViewKey, websitePrompt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [websitePrompt show];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITextFieldDelegate

// Enable the return key on the alert view.
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UIAlertView *alertView = objc_getAssociatedObject(textField, &kPSCAlertViewKey);
    if (alertView) { [alertView dismissWithClickedButtonIndex:1 animated:YES]; return YES;
    }else return NO;
}

@end
