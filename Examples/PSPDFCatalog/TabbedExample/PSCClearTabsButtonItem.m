//
//  PSCClearTabsButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCClearTabsButtonItem.h"

@implementation PSCClearTabsButtonItem {
    BOOL _isDismissingSheet;
}

- (UIBarButtonSystemItem)systemItem {
    return UIBarButtonSystemItemTrash;
}

- (id)presentAnimated:(BOOL)animated sender:(id)sender {
    PSPDFViewController *pdfController = self.pdfController;
    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:nil];
    _isDismissingSheet = NO;

    [actionSheet setDestructiveButtonWithTitle:PSPDFLocalize(@"Close all tabs") block:^{
        if ([pdfController.parentViewController isKindOfClass:[PSPDFTabbedViewController class]]) {
            PSPDFTabbedViewController *tabbedController = (PSPDFTabbedViewController *)pdfController.parentViewController;
            [tabbedController removeDocuments:tabbedController.documents animated:animated];
        }
    }];
    [actionSheet setCancelButtonWithTitle:PSPDFLocalize(@"Cancel") block:NULL];
    [actionSheet setDestroyBlock:^(PSPDFActionSheet *sheet, NSInteger buttonIndex) {
        // we don't get any delegates for the slide down animation on iPhone.
        // if we'd call dismissWithClickedButtonIndex again, the animation would be nil.
        _isDismissingSheet = YES;
        [self didDismiss];
    }];

    BOOL shouldShow = [pdfController delegateShouldShowController:actionSheet embeddedInController:nil animated:animated];
    if (shouldShow) {
        [actionSheet showWithSender:sender fallbackView:[pdfController masterViewController].view animated:animated];
        self.actionSheet = actionSheet;
        return self.actionSheet;
    }else {
        return nil;
    }
}

- (void)dismissAnimated:(BOOL)animated {
    if (_isDismissingSheet) return;
    [self.actionSheet dismissWithClickedButtonIndex:self.actionSheet.cancelButtonIndex animated:animated];
}

- (void)didDismiss {
    [super didDismiss];
    self.actionSheet = nil;
}

@end
