//
//  PSCGoToPageButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCGoToPageButtonItem.h"
#import "PSTAlertController.h"

@implementation PSCGoToPageButtonItem

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFBarButtonItem

- (instancetype)initWithPDFViewController:(PSPDFViewController *)pdfViewController {
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

- (void)action:(id)sender {
    [self.class dismissPopoverAnimated:YES completion:NULL];

    PSPDFViewController *pdfController = self.pdfController;

    PSTAlertController *gotoPageController = [PSTAlertController alertWithTitle:PSPDFLocalize(@"Go to page") message:nil];
    [gotoPageController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [gotoPageController addCancelActionWithHandler:NULL];
    [gotoPageController addAction:[PSTAlertAction actionWithTitle:PSPDFLocalize(@"Go to") handler:^(PSTAlertAction *action) {
        NSString *pageLabel = action.alertController.textField.text;
        if (pageLabel.length == 0) return;

        NSUInteger pageIndex = [pdfController.document pageForPageLabel:pageLabel partialMatching:self.enablePartialLabelMatching];

        // if input is just numeric, convert to page
        if (pageIndex == NSNotFound) {
            if (pageLabel.length > 0 && [pageLabel rangeOfCharacterFromSet:[NSCharacterSet.decimalDigitCharacterSet invertedSet]].length == 0) {
                pageIndex = pageLabel.integerValue;
                if (pageIndex == 0) pageIndex = NSNotFound; // 0 is invalid!
                else pageIndex--; // convert from user-page (starts at 1) to system (starts at 0)
            }
        }

        if (pageIndex == NSNotFound) {
            [[[UIAlertView alloc] initWithTitle:PSPDFLocalizeFormatted(@"Page %@ not found", pageLabel) message:nil delegate:nil cancelButtonTitle:PSPDFLocalize(@"Dismiss") otherButtonTitles:nil] show];
        } else {
            [pdfController setViewMode:PSPDFViewModeDocument animated:YES];
            [pdfController setPage:pageIndex animated:YES];
        }
    }]];
    [gotoPageController showWithSender:self controller:nil animated:YES completion:NULL];
}


@end
