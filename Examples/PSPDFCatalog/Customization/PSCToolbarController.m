//
//  PSPDFCustomToolbarController.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCToolbarController.h"
#import <tgmath.h>

@interface PSCToolbarController ()
@property (nonatomic, strong) UISegmentedControl *customViewModeSegment;
@property (nonatomic, assign) CGSize *originalThumbnailSize;
@end

@implementation PSCToolbarController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (void)commonInitWithDocument:(PSPDFDocument *)document configuration:(PSPDFConfiguration *)configuration {
    configuration = [configuration configurationUpdatedWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        builder.renderAnimationEnabled = NO; // custom implementation here
        builder.thumbnailSize = PSCIsIPad() ? CGSizeMake(235.f, 305.f) : CGSizeMake(200.f, 250.f);
    }];
    [super commonInitWithDocument:document configuration:configuration];

    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Custom" image:[UIImage imageNamed:@"balloon"] tag:2];

    // add custom controls to our toolbar
    _customViewModeSegment = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Page", @""), NSLocalizedString(@"Thumbnails", @"")]];
    _customViewModeSegment.selectedSegmentIndex = 0;
    [_customViewModeSegment addTarget:self action:@selector(viewModeSegmentChanged:) forControlEvents:UIControlEventValueChanged];
    [_customViewModeSegment sizeToFit];
    UIBarButtonItem *viewModeButton = [[UIBarButtonItem alloc] initWithCustomView:_customViewModeSegment];

    self.navigationItem.rightBarButtonItems = @[viewModeButton, self.printButtonItem, self.searchButtonItem, self.emailButtonItem, self.annotationButtonItem];

    // UIBarButtons are defaulted to be plain in PSPDFKit. Iterate and update them to improve image rendering and positioning in bordered.
    for (UIBarButtonItem *barButton in self.navigationItem.rightBarButtonItems) {
        barButton.style = UIBarButtonItemStyleBordered;
    }

    self.delegate = self;
}

- (void)dealloc {
    self.delegate = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)viewModeSegmentChanged:(id)sender {
    UISegmentedControl *viewMode = (UISegmentedControl *)sender;
    NSUInteger selectedSegment = viewMode.selectedSegmentIndex;
    [self setViewMode:selectedSegment == 0 ? PSPDFViewModeDocument : PSPDFViewModeThumbnails animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

// simple example how to re-color the link annotations
- (void)pdfViewController:(PSPDFViewController *)pdfController willShowAnnotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView onPageView:(PSPDFPageView *)pageView {
    if ([annotationView isKindOfClass:[PSPDFLinkAnnotationView class]]) {
        PSPDFLinkAnnotationView *linkAnnotation = (PSPDFLinkAnnotationView *)annotationView;
        linkAnnotation.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.7f];
    }
}

#define PSPDFLoadingViewTag 225475
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    self.navigationItem.title = [NSString stringWithFormat:@"Custom always visible header bar. Page %tu", pageView.page];
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode {
    [_customViewModeSegment setSelectedSegmentIndex:(NSUInteger)viewMode];
}

// *** implemented just for your curiosity. you can use that to add custom views (e.g. videos) to the PSPDFScrollView ***

// called after pdf page has been loaded and added to the pagingScrollView
- (void)pdfViewController:(PSPDFViewController *)pdfController didLoadPageView:(PSPDFPageView *)pageView {
    NSLog(@"didLoadPageView: %@", pageView);

    // add loading indicator
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[pageView viewWithTag:PSPDFLoadingViewTag];
    if (!indicator) {
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator sizeToFit];
        [indicator startAnimating];
        indicator.tag = PSPDFLoadingViewTag;
        indicator.frame = CGRectMake(__tg_floor((pageView.frame.size.width - indicator.frame.size.width)/2.f), __tg_floor((pageView.frame.size.height - indicator.frame.size.height)/2.f), indicator.frame.size.width, indicator.frame.size.height);
        [pageView addSubview:indicator];
    }
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPageView:(PSPDFPageView *)pageView {
    NSLog(@"page %@ rendered.", pageView);

    // remove loading indicator
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[pageView viewWithTag:PSPDFLoadingViewTag];
    if (indicator) {
        [UIView animateWithDuration:0.25f delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            indicator.alpha = 0.f;
        } completion:^(BOOL finished) {
            [indicator removeFromSuperview];
        }];
    }
}

@end
