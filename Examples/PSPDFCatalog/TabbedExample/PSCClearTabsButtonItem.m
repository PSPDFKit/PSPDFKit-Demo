//
//  PSCClearTabsButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 PSPDFKit. All rights reserved.
//

#import "PSCClearTabsButtonItem.h"

@implementation PSCClearTabsButtonItem {
    BOOL _isDismissingSheet;
}

- (UIBarButtonSystemItem)systemItem {
    return UIBarButtonSystemItemTrash;
}

- (id)presentAnimated:(BOOL)animated sender:(id)sender {
    PSPDFActionSheet *actionSheet = [[PSPDFActionSheet alloc] initWithTitle:nil];
    _isDismissingSheet = NO;

    [actionSheet setDestructiveButtonWithTitle:PSPDFLocalize(@"Clear All Tabs") block:^{
        if ([self.pdfController.parentViewController isKindOfClass:[PSPDFTabbedViewController class]]) {
            PSPDFTabbedViewController *tabbedController = (PSPDFTabbedViewController *)self.pdfController.parentViewController;
            [tabbedController removeDocuments:tabbedController.documents animated:animated];
        }
    }];
    [actionSheet setCancelButtonWithTitle:PSPDFLocalize(@"Cancel") block:NULL];
    actionSheet.destroyBlock = ^{
        // we don't get any delegates for the slide down animation on iPhone.
        // if we'd call dismissWithClickedButtonIndex again, the animation would be nil.
        _isDismissingSheet = YES;
        [self didDismiss];
    };

    BOOL shouldShow = [self.pdfController delegateShouldShowController:actionSheet embeddedInController:nil animated:animated];
    if (shouldShow) {
        if (PSIsIpad() && [sender isKindOfClass:[UIBarButtonItem class]]) {
            [actionSheet showFromBarButtonItem:sender animated:animated];
        }else if (PSIsIpad() && [sender isKindOfClass:[UIView class]]) {
            [actionSheet showFromRect:[sender bounds] inView:sender animated:animated];
        }else {
            [actionSheet showInView:[self.pdfController masterViewController].view];
        }
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
