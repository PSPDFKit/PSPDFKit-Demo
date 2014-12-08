//
//  PSCButtonPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCButtonPDFViewController.h"

// Container to add a UIButton always centered at the page.
@interface PSCButtonContainerView : UIView <PSPDFAnnotationViewProtocol>
@property (nonatomic, strong) UIButton *button;
@end

@implementation PSCButtonPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        // register for the delegate.
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
        PSCButtonContainerView *buttonContainer = [[PSCButtonContainerView alloc] initWithFrame:CGRectZero];
        [buttonContainer.button setTitle:@"Press me!" forState:UIControlStateNormal];
        [buttonContainer.button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [buttonContainer sizeToFit];
        [pageView.annotationContainerView addSubview:buttonContainer];
        [buttonContainer didChangePageBounds:pageView.bounds]; // layout initially
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)buttonPressed:(UIButton *)sender {
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Button pressed on page %tu.", self.page+1] message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end


@implementation PSCButtonContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self addSubview:self.button];
    }
    return self;
}

- (void)sizeToFit {
    [self.button sizeToFit];
    self.frame = self.button.bounds;
}

// called initially and on rotation change
- (void)didChangePageBounds:(CGRect)bounds {
    self.center = self.superview.center;
    self.frame = CGRectIntegral(self.frame);
}

@end
