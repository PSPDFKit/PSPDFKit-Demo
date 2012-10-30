//
//  PSCButtonPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 PSPDFKit. All rights reserved.
//

#import "PSCButtonPDFViewController.h"

@implementation PSCButtonPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        // register for the delegate
        self.delegate = self;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView {
    // add custom button at pageView on page 0.
    // PSPDF will re-use PSPDFPageView but will also clear all "foreign" added views - you don't have to remove it yourself.
    // The didLoadPageView will be called once while the pageView is processed for the new page, so it's the perfect time to add custom views.
    if (pageView.page == 0) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button setTitle:@"Press me!" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.frame = PSPDFAlignRectangles(button.frame, pageView.bounds, PSPDFRectAlignCenter); // helper to center frame.
        [pageView addSubview:button];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)buttonPressed:(UIButton *)sender {
    [[[UIAlertView alloc] initWithTitle:@"Button pressed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end
