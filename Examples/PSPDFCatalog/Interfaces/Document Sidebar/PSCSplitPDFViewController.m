//
//  PSCSplitPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCSplitPDFViewController.h"

@interface PSCSplitPDFViewController()
@property (nonatomic, strong) UIPopoverController *masterPopoverController;
@end

// It would be much better if we directly use PSPDFViewController, or reuse an embedded PSPDFViewController and modify the document via the .document property.
// This technique is used to test fast creation/destroying of the viewController.
@implementation PSCSplitPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)init {
    if ((self = [super init])) {
        self.delegate = self;
        self.leftBarButtonItems = nil;
        self.additionalBarButtonItems = @[self.printButtonItem, self.emailButtonItem];
        self.rightBarButtonItems = @[self.bookmarkButtonItem, self.searchButtonItem, self.viewModeButtonItem];

    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems inNavigationItem:(UINavigationItem *)navigationItem animated:(BOOL)animated {
    // NOP. We manage that part ourselves.
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)displayDocument:(PSPDFDocument *)document page:(NSUInteger)pageIndex {
    // Dismiss any open popovers.
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }

    // anyway, set document
    self.document = document;
    self.page = pageIndex;

#if defined(PSCEnableDocumentStressTest) && PSCEnableDocumentStressTest
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [[document outlineParser] outline];
        [[document copy] renderImageForPage:0 withSize:CGSizeMake(200.f, 200.f) clippedToRect:CGRectZero withAnnotations:nil options:nil];
    });
#endif

    // Initially manually call the delegate for first load.
    [self updateTitle];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UISplitViewControllerDelegate

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

- (void)updateTitle {
    if (self.document) {
        // Internally, pages start at 0. But be user-friendly and start at 1.
        self.title = [NSString stringWithFormat:@"%@ - Page %tu", self.document.title, self.page];
    } else {
        self.title = @"No document loaded.";
        [self setHUDVisible:NO animated:NO]; // ensure HUD is disabled if no document is loaded.
    }
}

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    [self updateTitle];
}

@end
