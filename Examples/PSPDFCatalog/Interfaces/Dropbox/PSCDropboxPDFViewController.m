//
//  PSCDropboxPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSCDropboxPDFViewController.h"

@interface PSCDropboxPDFViewController () <PSPDFViewControllerDelegate>

@end

@implementation PSCDropboxPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];

    self.pageTransition = PSPDFPageScrollContinuousTransition;
    self.scrollDirection = PSPDFScrollDirectionVertical;
    self.statusBarStyleSetting = PSPDFStatusBarDefault;
    self.shouldHideStatusBarWithHUD = NO;
    self.renderAnimationEnabled = NO;
    self.scrobbleBarEnabled = NO;
    self.leftBarButtonItems = nil;
    self.rightBarButtonItems = nil;
    self.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Add the floating toolbar to the HUD
    self.floatingToolbar = [PSCDropboxFloatingToolbar new];
    self.floatingToolbar.frame = CGRectMake(20, 20, 0, 0);
    [self updateFloatingToolbarAnimated:NO]; // will update size.
    [self.HUDView addSubview:self.floatingToolbar];
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
    [UIView animateWithDuration:animated ? 0.25 : 0.f animations:^{
        BOOL showToolbar = self.document.isValid && self.viewMode == PSPDFViewModeDocument;
        self.floatingToolbar.alpha = showToolbar ? 0.8f : 0.f;
    }];

    NSMutableArray *floatingToolbarButtons = [NSMutableArray array];

    UIButton *thumbnailButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [thumbnailButton setAccessibilityLabel:PSPDFLocalize(@"Thumbnails")];
    [thumbnailButton setImage:[PSPDFIconGenerator.sharedGenerator iconForType:PSPDFIconTypeThumbnails] forState:UIControlStateNormal];
    [thumbnailButton addTarget:self action:@selector(thumbnailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [floatingToolbarButtons addObject:thumbnailButton];

    if (self.document.outlineParser.isOutlineAvailable) {
        UIButton *outlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [outlineButton setAccessibilityLabel:PSPDFLocalize(@"Outline")];
        [outlineButton setImage:[PSPDFIconGenerator.sharedGenerator iconForType:PSPDFIconTypeOutline] forState:UIControlStateNormal];
        [outlineButton addTarget:self action:@selector(outlineButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [floatingToolbarButtons addObject:outlineButton];
    }

    // TODO search icon
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setAccessibilityLabel:PSPDFLocalize(@"Search")];
    [searchButton setImage:PSPDFApplyToolbarShadowToImage([UIImage imageNamed:@"search"]) forState:UIControlStateNormal];
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
    [self presentViewControllerModalOrPopover:outlineViewController embeddedInNavigationController:!PSIsIpad() withCloseButton:YES animated:YES sender:sender options:@{PSPDFPresentOptionAllowedPopoverArrowDirections : @(UIPopoverArrowDirectionUp)}];
}

- (void)searchButtonPressed:(UIButton *)sender {
    PSPDFSearchViewController *searchController = [[PSPDFSearchViewController alloc] initWithDocument:self.document pdfController:self];
    [self presentViewControllerModalOrPopover:searchController embeddedInNavigationController:NO withCloseButton:YES animated:YES sender:sender options:@{PSPDFPresentOptionAllowedPopoverArrowDirections : @(UIPopoverArrowDirectionUp)}];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didChangeViewMode:(PSPDFViewMode)viewMode {
    [self updateFloatingToolbarAnimated:YES];
}

@end
