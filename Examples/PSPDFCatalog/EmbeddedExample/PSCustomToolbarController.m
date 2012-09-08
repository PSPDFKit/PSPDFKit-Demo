//
//  PSPDFCustomToolbarController.m
//  PSPDFCatalog
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSCustomToolbarController.h"

@implementation PSCustomToolbarController {
    UISegmentedControl *_customViewModeSegment;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Custom" image:[UIImage imageNamed:@"balloon"] tag:2];
        
        // disable default toolbar
        [self setToolbarEnabled:NO];
        self.statusBarStyleSetting = PSPDFStatusBarInherit;
        self.renderAnimationEnabled = NO; // custom implementation here
        
        // add custom controls to our toolbar
        _customViewModeSegment = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"Page", @""), NSLocalizedString(@"Thumbnails", @"")]];
        _customViewModeSegment.selectedSegmentIndex = 0;
        _customViewModeSegment.segmentedControlStyle = UISegmentedControlStyleBar;
        [_customViewModeSegment addTarget:self action:@selector(viewModeSegmentChanged:) forControlEvents:UIControlEventValueChanged];
        [_customViewModeSegment sizeToFit];
        UIBarButtonItem *viewModeButton = [[UIBarButtonItem alloc] initWithCustomView:_customViewModeSegment];

        // rightBarButtonItems is iOS5 only
        if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_5_0) {
            self.navigationItem.rightBarButtonItems = @[viewModeButton, self.printButtonItem, self.searchButtonItem, self.emailButtonItem];
        }else {
            self.navigationItem.rightBarButtonItem = viewModeButton;
        }
        self.delegate = self;
        
        // use large thumbnails!
        self.thumbnailSize = CGSizeMake(300, 300);
        
        // don't forget to also set the large size in PSPDFCache!
        [PSPDFCache sharedCache].thumbnailSize = self.thumbnailSize;
    }
    return self;
}

- (void)dealloc {
    self.delegate = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return PSIsIpad() ? YES : toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)viewModeSegmentChanged:(id)sender {
    UISegmentedControl *viewMode = (UISegmentedControl *)sender;
    NSUInteger selectedSegment = viewMode.selectedSegmentIndex;
    NSLog(@"selected segment index: %d", selectedSegment);
    [self setViewMode:selectedSegment == 0 ? PSPDFViewModeDocument : PSPDFViewModeThumbnails animated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

// simple example how to re-color the link annotations
- (void)pdfViewController:(PSPDFViewController *)pdfController willShowAnnotationView:(UIView <PSPDFAnnotationView> *)annotationView onPageView:(PSPDFPageView *)pageView {
    if ([annotationView isKindOfClass:[PSPDFLinkAnnotationView class]]) {
        PSPDFLinkAnnotationView *linkAnnotation = (PSPDFLinkAnnotationView *)annotationView;
        linkAnnotation.borderColor = [[UIColor blueColor] colorWithAlphaComponent:0.7f];
    }
}

#define PSPDFLoadingViewTag 225475
- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    self.navigationItem.title = [NSString stringWithFormat:@"Custom always visible header bar. Page %d", pageView.page];    
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode; {
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
        indicator.frame = CGRectMake(floorf((pageView.frame.size.width - indicator.frame.size.width)/2), floorf((pageView.frame.size.height - indicator.frame.size.height)/2), indicator.frame.size.width, indicator.frame.size.height);
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

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnPageView:(PSPDFPageView *)pageView info:(PSPDFPageInfo *)pageInfo coordinates:(PSPDFPageCoordinates *)pageCoordinates {
    NSLog(@"didTapOnPageView: %d coordinates: %@", pageView.page, pageCoordinates);
    return NO;
}

@end
