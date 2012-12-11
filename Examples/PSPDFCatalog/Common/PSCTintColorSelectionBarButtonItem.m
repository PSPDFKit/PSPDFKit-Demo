//
//  PSCTintColorSelectionBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCTintColorSelectionBarButtonItem.h"

@interface PSCTintColorSelectionBarButtonItem () <PSPDFColorSelectionViewControllerDelegate> {
    PSPDFColorButton *_strokeColorButton;
}
@end

@implementation PSCTintColorSelectionBarButtonItem

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFBarButtonItem

- (void)updateBarButtonItem {
    [super updateBarButtonItem];
    _strokeColorButton.color = self.pdfController.tintColor;
    [self updateButtonSize];
}

- (BOOL)isAvailable {
    return YES;
}

- (NSString *)actionName {
    return NSLocalizedString(@"Tint Color", @"");
}

- (void)updateButtonSize {
    // as we lock orientation, button size needs to be checked only here.
    CGFloat buttonSize = roundf(PSPDFToolbarHeightForOrientation(self.pdfController.interfaceOrientation) * 0.75f);
    _strokeColorButton.frame = (CGRect){.origin = _strokeColorButton.frame.origin, .size=CGSizeMake(buttonSize, buttonSize)};
}

- (UIView *)customView {
    if (!_strokeColorButton) {
        _strokeColorButton = [PSPDFColorButton buttonWithType:UIButtonTypeCustom];
        [self updateButtonSize];

        _strokeColorButton.color = self.pdfController.tintColor;
        _strokeColorButton.displayAsEllipse = YES;
        [_strokeColorButton addTarget:self action:@selector(selectStrokeColor:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _strokeColorButton;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)selectStrokeColor:(id)sender {
    BOOL alreadyDisplayed = PSPDFIsControllerClassInPopoverAndVisible(self.pdfController.popoverController, [PSPDFSimplePageViewController class]);
    if (alreadyDisplayed) {
        [self.pdfController.popoverController dismissPopoverAnimated:YES];
        self.pdfController.popoverController = nil;
    }else {
        NSString *viewControllerTitle = NSLocalizedString(@"Tint Color", @"");
        PSPDFSimplePageViewController *colorPicker = [PSPDFColorSelectionViewController defaultColorPickerWithTitle:viewControllerTitle delegate:self];
        if (colorPicker) {
            [self.pdfController presentViewControllerModalOrPopover:colorPicker embeddedInNavigationController:YES withCloseButton:YES animated:YES sender:self options:@{PSPDFPresentOptionPassthroughViews : @[sender]}];
        }else {
            PSPDFLogError(@"Color picker can't be displayed. Is PSPDFKit.bundle missing?");
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFColorSelectionViewControllerDelegate

- (UIColor *)colorSelectionControllerSelectedColor:(PSPDFColorSelectionViewController *)controller {
    return self.pdfController.tintColor;
}

- (void)colorSelectionController:(PSPDFColorSelectionViewController *)controller didSelectedColor:(UIColor *)color {
    controller.navigationController.navigationBar.tintColor = color;
    self.pdfController.tintColor = color;
    [self dismissModalOrPopoverAnimated:YES];
    [self.pdfController createToolbarAnimated:NO];
}

@end
