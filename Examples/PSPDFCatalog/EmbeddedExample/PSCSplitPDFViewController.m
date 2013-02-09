//
//  PSCSplitPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 Peter Steinberger. All rights reserved.
//

#import "PSCSplitPDFViewController.h"

@interface PSCSplitPDFViewController()
@property (nonatomic, strong) UIPopoverController *masterPopoverController;
@end

// note that it would be much better if we directly use PSPDFViewController,
// or reuse an embedded PSPDFViewController and modify the document via the .document property
// this technique is used to test fast creation/destroying of the viewController
@implementation PSCSplitPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        self.delegate = self;
        self.leftBarButtonItems = nil;
        self.additionalBarButtonItems = @[self.printButtonItem, self.emailButtonItem];
        self.rightBarButtonItems = @[self.searchButtonItem, self.viewModeButtonItem];
        self.statusBarStyleSetting = PSPDFStatusBarDefault;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)displayDocument:(PSPDFDocument *)document; {
    // dismiss any open popovers
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    } 
    
    // anyway, set document
    self.document = document;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - SplitView

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    if (pageView.document) {
        // internally, pages start at 0. But be user-friendly and start at 1.
        self.title = [NSString stringWithFormat:@"%@ - Page %d", pageView.document.title, pageView.page + 1];    
    }else {
        self.title = @"No document loaded.";
        [self setHUDVisible:NO animated:NO]; // ensure HUD is disabled if no document is loaded.
    }
}

@end
