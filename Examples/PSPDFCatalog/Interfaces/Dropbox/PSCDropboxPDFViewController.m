//
//  PSCDropboxPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCDropboxPDFViewController.h"
#import "UIImage+Tinting.h"

static const CGFloat PSCToolbarMargin = 20.f;

@interface UIImage (PSCatalogAdditions)
- (UIImage *)psc_imageTintedWithColor:(UIColor *)color fraction:(CGFloat)fraction;
@end

@interface PSCDropboxPDFViewController () <PSPDFViewControllerDelegate>
@end

@implementation PSCDropboxPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];

    self.pageTransition = PSPDFPageTransitionScrollContinuous;
    self.scrollDirection = PSPDFScrollDirectionVertical;
    self.renderAnimationEnabled = NO;
    self.thumbnailBarMode = PSPDFThumbnailBarModeNone;
    self.thumbnailController.filterOptions = nil;
    self.outlineButtonItem.availableControllerOptions = [NSOrderedSet orderedSetWithObject:@(PSPDFOutlineBarButtonItemOptionOutline)];
    self.leftBarButtonItems = nil;
    self.rightBarButtonItems = nil;
    self.delegate = self;

    if (!PSCIsIPad()) {
        self.title = document.title;
        self.documentLabelEnabled = NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add the floating toolbar to the HUD.
    self.floatingToolbar = [[PSCDropboxFloatingToolbar alloc] initWithFrame:CGRectMake(PSCToolbarMargin, PSCToolbarMargin, 0.f, 0.f)];
    [self updateFloatingToolbarAnimated:NO]; // will update size.
    [self.HUDView addSubview:self.floatingToolbar];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];
	CGRect frame = self.floatingToolbar.frame;
	frame.origin.y = PSCToolbarMargin + self.topLayoutGuide.length;
	// Keep the fixed position, even if the status bar gets hidden
	if ([UIApplication sharedApplication].statusBarHidden) frame.origin.y += 20.f;
	self.floatingToolbar.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)setDocument:(PSPDFDocument *)document {
    [super setDocument:document];
    [self updateFloatingToolbarAnimated:self.isViewLoaded];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)updateFloatingToolbarAnimated:(BOOL)animated {
    [UIView animateWithDuration:animated ? 0.25f : 0.f animations:^{
        BOOL showToolbar = self.document.isValid && self.viewMode == PSPDFViewModeDocument;
        self.floatingToolbar.alpha = showToolbar ? 0.8f : 0.f;
    }];

    NSMutableArray *floatingToolbarButtons = [NSMutableArray array];

    UIButton *thumbnailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [thumbnailButton setAccessibilityLabel:PSPDFLocalize(@"Thumbnails")];
    [thumbnailButton setImage:[PSPDFBundleImage(@"thumbnails") psc_imageTintedWithColor:UIColor.whiteColor fraction:0.f] forState:UIControlStateNormal];
    [thumbnailButton addTarget:self action:@selector(thumbnailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [floatingToolbarButtons addObject:thumbnailButton];

    if (self.document.outlineParser.isOutlineAvailable) {
        UIButton *outlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [outlineButton setAccessibilityLabel:PSPDFLocalize(@"Outline")];
        [outlineButton setImage:[PSPDFBundleImage(@"outline") psc_imageTintedWithColor:UIColor.whiteColor fraction:0.f] forState:UIControlStateNormal];
        [outlineButton addTarget:self action:@selector(outlineButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [floatingToolbarButtons addObject:outlineButton];
    }

    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setAccessibilityLabel:PSPDFLocalize(@"Search")];
    [searchButton setImage:[PSPDFBundleImage(@"search") psc_imageTintedWithColor:UIColor.whiteColor fraction:0.f] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [floatingToolbarButtons addObject:searchButton];

    self.floatingToolbar.buttons = floatingToolbarButtons;
}

- (void)thumbnailButtonPressed:(UIButton *)sender {
    if (self.viewMode == PSPDFViewModeDocument) {
        [self setViewMode:PSPDFViewModeThumbnails animated:YES];
    }else {
        [self setViewMode:PSPDFViewModeDocument animated:YES];
    }
}

- (void)outlineButtonPressed:(UIButton *)sender {
    PSPDFOutlineViewController *outlineViewController = [[PSPDFOutlineViewController alloc] initWithDocument:self.document delegate:self];
    [self presentModalOrInPopover:outlineViewController embeddedInNavigationController:!PSCIsIPad() withCloseButton:YES animated:YES sender:sender options:@{PSPDFPresentOptionPopoverArrowDirections : @(UIPopoverArrowDirectionUp)}];
}

- (void)searchButtonPressed:(UIButton *)sender {
    PSPDFSearchViewController *searchController = [[PSPDFSearchViewController alloc] initWithDocument:self.document delegate:self];
    [self presentModalOrInPopover:searchController embeddedInNavigationController:NO withCloseButton:YES animated:YES sender:sender options:@{PSPDFPresentOptionPopoverArrowDirections : @(UIPopoverArrowDirectionUp)}];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode {
    [self updateFloatingToolbarAnimated:YES];
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    NSLog(@"didShowPageView: page:%tu", pageView.page);
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didRenderPageView:(PSPDFPageView *)pageView {
    NSLog(@"didRenderPageView: page:%tu", pageView.page);
}

@end
