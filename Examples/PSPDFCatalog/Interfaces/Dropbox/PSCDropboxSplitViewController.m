//
//  PSCDropboxSplitViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCDropboxSplitViewController.h"
#import "PSCAppDelegate.h"

@interface PSCDropboxSplitViewController () <UISplitViewControllerDelegate, PSCDocumentSelectorControllerDelegate>
@property (nonatomic, strong) PSPDFDocumentSelectorController *documentSelector;
@property (nonatomic, strong) PSCDropboxPDFViewController *pdfController;
@property (nonatomic, strong) UIBarButtonItem *backToCatalogButton;
@end

@implementation PSCDropboxSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.delegate = self;
        _showLeftPaneInLandscape = YES;

        self.documentSelector = [[PSPDFDocumentSelectorController alloc] initWithDirectory:@"/Bundle/Samples" delegate:self];
        self.documentSelector.stickySearchBar = YES;
        self.documentSelector.delegate = self;

        self.pdfController = [PSCDropboxPDFViewController new];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:self.pdfController];

        self.viewControllers = @[self.documentSelector, navController];

        self.backToCatalogButton = [[UIBarButtonItem alloc] initWithTitle:@"Catalog" style:UIBarButtonItemStyleBordered target:self action:@selector(backToCatalog:)];
    }
    return self;
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
    [self.view.window.layer addAnimation:PSPDFFadeTransition() forKey:nil];
    self.view.window.rootViewController = ((PSCAppDelegate *)UIApplication.sharedApplication.delegate).catalog;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return UIInterfaceOrientationIsPortrait(orientation) || (!self.showLeftPaneInLandscape && UIInterfaceOrientationIsLandscape(orientation));
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.pdfController.navigationItem setLeftBarButtonItems:@[barButtonItem, self.backToCatalogButton] animated:YES];
    //self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.pdfController.navigationItem setLeftBarButtonItem:self.backToCatalogButton animated:YES];
    //self.masterPopoverController = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCDocumentSelectorControllerDelegate

- (void)documentSelectorController:(PSPDFDocumentSelectorController *)controller didSelectDocument:(PSPDFDocument *)document {
    self.pdfController.document = document;
}

@end
