//
//  PSCBookViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCBookViewController.h"

@interface PSCBookPageViewController : PSPDFPageViewController @end
@interface PSCBookSinglePageViewController : PSPDFSinglePageViewController @end

@implementation PSCBookViewController

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {

        self.pageTransition = PSPDFPageCurlTransition;

        // disable features that don't work with custom PSPDFPageView frame manipulation
        self.smartZoomEnabled = NO;
        self.renderAnimationEnabled = NO;

        // we have a background image, no extra shadow needed.
        self.shadowEnabled = NO;

        // override certain classes to achieve the book-style layout
        [self overrideClass:PSPDFPageViewController.class withClass:PSCBookPageViewController.class];
        [self overrideClass:PSPDFSinglePageViewController.class withClass:PSCBookSinglePageViewController.class];
    }
    return self;
}

@end

// ensure we use full-screen and not dynamic sizing
@implementation PSCBookPageViewController

- (void)updateViewSize {
    // cancel if we're zoomed in
    if (!self.isViewLoaded || self.scrollView.zoomScale != 1.f) return;

    // full-screen, always
    self.view.frame = self.pdfController.view.bounds;
}

@end

// add background image
@implementation PSCBookSinglePageViewController {
    UIImageView *_backgroundImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _backgroundImage = [[UIImageView alloc] initWithImage:nil];
    _backgroundImage.contentMode = UIViewContentModeScaleToFill;
    [self.view insertSubview:_backgroundImage belowSubview:self.pageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (!self.isViewLoaded) {
        _backgroundImage = nil;
    }
}

- (void)updateBackgroundView {
    BOOL isRightPage = [self.pdfController isDoublePageMode] && [self.pdfController isRightPageInDoublePageMode:self.page];

    _backgroundImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"book-%@.jpg", isRightPage ? @"right" : @"left"]];

    // remove image if we are on an invalid page (e.g. left page on first page with cover page mode)
    if (self.page == NSUIntegerMax) {
        _backgroundImage.image = nil;
    }
}

- (void)layoutPage {
    [super layoutPage];

    // always update background
    [self updateBackgroundView];
    _backgroundImage.frame = self.view.bounds;

    if (self.page == NSUIntegerMax || self.page >= self.pdfController.document.pageCount) {
        return;
    }

    // rely on super layoutPage to lay out the page and then just alter the coordinates.
    CGSize newSize = CGSizeMake(roundf(self.pageView.bounds.size.width * 0.87f), roundf(self.pageView.bounds.size.height * 0.87f));
    CGRect newFrame = CGRectInset(self.pageView.frame, self.pageView.bounds.size.width - newSize.width, self.pageView.bounds.size.height - newSize.height);
    self.pageView.frame = newFrame;
}

@end
