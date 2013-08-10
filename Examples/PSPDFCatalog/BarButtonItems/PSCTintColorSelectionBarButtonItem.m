//
//  PSCTintColorSelectionBarButtonItem.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
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
    CGFloat buttonSize = roundf(PSCToolbarHeightForOrientation(self.pdfController.interfaceOrientation) * 0.75f);
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
    PSPDFViewController *pdfController = self.pdfController;
    
    BOOL alreadyDisplayed = PSPDFIsControllerClassAndVisible(pdfController.popoverController, [PSPDFSimplePageViewController class]);
    if (alreadyDisplayed) {
        [pdfController.popoverController dismissPopoverAnimated:YES];
        pdfController.popoverController = nil;
    }else {
        NSString *viewControllerTitle = NSLocalizedString(@"Tint Color", @"");
        PSPDFSimplePageViewController *colorPicker = [PSPDFColorSelectionViewController defaultColorPickerWithTitle:viewControllerTitle wantTransparency:NO delegate:self context:NULL];
        if (colorPicker) {
            [pdfController presentModalOrInPopover:colorPicker embeddedInNavigationController:YES withCloseButton:YES animated:YES sender:self options:@{PSPDFPresentOptionPassthroughViews : @[sender]}];
        }else {
            NSLog(@"Color picker can't be displayed. Is PSPDFKit.bundle missing?");
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFColorSelectionViewControllerDelegate

- (UIColor *)colorSelectionControllerSelectedColor:(PSPDFColorSelectionViewController *)controller context:(void *)context {
    return self.pdfController.tintColor;
}

- (void)colorSelectionController:(PSPDFColorSelectionViewController *)controller didSelectColor:(UIColor *)color finishedSelection:(BOOL)finished context:(void *)context {
    controller.navigationController.navigationBar.tintColor = color;
    PSPDFViewController *pdfController = self.pdfController;
    pdfController.tintColor = color;
    [self dismissModalOrPopoverAnimated:YES completion:NULL];
    [pdfController createToolbarAnimated:NO];
}

@end
