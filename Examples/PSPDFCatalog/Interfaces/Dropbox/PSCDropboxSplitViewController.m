//
//  PSCDropboxSplitViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCDropboxSplitViewController.h"
#import "PSCAppDelegate.h"

@interface PSCDropboxSplitViewController () <UISplitViewControllerDelegate, PSPDFDocumentPickerControllerDelegate>
@property (nonatomic, strong) PSPDFDocumentPickerController *documentPicker;
@property (nonatomic, strong) PSCDropboxPDFViewController *pdfController;
@property (nonatomic, strong) UIBarButtonItem *backToCatalogButton;
@property (nonatomic, strong) UIPopoverController *masterPopoverController;
@end

@implementation PSCDropboxSplitViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _showLeftPaneInLandscape = YES;

        // Create global back button
        self.backToCatalogButton = [[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStyleBordered target:self action:@selector(backToCatalog:)];

        // Create the document picker
        self.documentPicker = [[PSPDFDocumentPickerController alloc] initWithDirectory:@"/Bundle/Samples" includeSubdirectories:YES library:PSPDFLibrary.defaultLibrary delegate:self];
        self.documentPicker.delegate = self;

        // Create the PDF controller
        self.pdfController = [PSCDropboxPDFViewController new];
        self.pdfController.barButtonItemsAlwaysEnabled = @[self.backToCatalogButton];
        self.pdfController.leftBarButtonItems = @[self.backToCatalogButton];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.pdfController];

        // Set up the split controller
        self.viewControllers = @[self.documentPicker, navController];
        self.delegate = self;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)setShowLeftPaneInLandscape:(BOOL)showLeftPaneInLandscape {
    if (_showLeftPaneInLandscape != showLeftPaneInLandscape) {
        // HACK: http://stackoverflow.com/questions/8020323/how-to-hide-unhide-master-view-controller-in-splitview-controller
        [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)backToCatalog:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:NULL];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsPortrait(orientation) || (!self.showLeftPaneInLandscape && UIInterfaceOrientationIsLandscape(orientation));
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    self.pdfController.barButtonItemsAlwaysEnabled = @[barButtonItem, self.backToCatalogButton];
    self.pdfController.leftBarButtonItems = @[barButtonItem, self.backToCatalogButton];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    self.pdfController.leftBarButtonItems = @[self.backToCatalogButton];
    self.masterPopoverController = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentPickerControllerDelegate

- (void)documentPickerController:(PSPDFDocumentPickerController *)documentPickerController didSelectDocument:(PSPDFDocument *)document page:(NSUInteger)pageIndex searchString:(NSString *)searchString {
    self.pdfController.document = document;
    self.pdfController.page = pageIndex;

    if (searchString && documentPickerController.fullTextSearchEnabled) {
        [self.pdfController searchForString:searchString options:@{PSPDFViewControllerSearchHeadlessKey : @YES} animated:YES];
    }
}

- (void)documentPickerControllerWillEndSearch:(PSPDFDocumentPickerController *)documentPickerController {
    [self.pdfController.searchHighlightViewManager clearHighlightedSearchResultsAnimated:NO];
}

@end
