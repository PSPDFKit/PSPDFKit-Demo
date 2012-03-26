//
//  SplitMasterViewController.m
//  EmbeddedExample
//
//  Created by Peter Steinberger on 8/22/11.
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "SplitMasterViewController.h"

#define kPSPDFReusePDFViewController YES

@interface SplitMasterViewController() 
@property(nonatomic, strong) PSPDFViewController *pdfController;
@property (nonatomic, strong) UIPopoverController *masterPopoverController;
@end

// note that it would be much better if we directly use PSPDFViewController,
// or reuse an embedded PSPDFViewController and modify the document via the .document property
// this technique is used to test fast creation/destroying of the viewController
@implementation SplitMasterViewController

@synthesize pdfController = pdfController_;
@synthesize masterPopoverController = masterPopoverController_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)createPdfController {
    self.pdfController.delegate = nil;
    self.pdfController = [[PSPDFViewController alloc] init];
    self.pdfController.delegate = self;
    self.pdfController.pageCurlEnabled = YES;
    
    pdfController_.view.frame = self.view.bounds;
    [[pdfController_ view] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    //[pdfController_ setPageMode:PSPDFPageModeSingle];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        self.title = @"Embedded PSPDFViewController";
    }
    return self;
}

- (void)dealloc {
    pdfController_.delegate = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createPdfController];

    if (self.pdfController) {
        [self.view addSubview:self.pdfController.view];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.pdfController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.pdfController viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.pdfController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.pdfController viewDidDisappear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)displayDocument:(PSPDFDocument *)document; {
    
    // dismiss any open popovers
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    } 
    
    // if reusing is active (advised), create controller only once
    if (kPSPDFReusePDFViewController) {
        if (!self.pdfController) {
            [self createPdfController];
        }
    }else {
    
    // if controller is already displayed, destroy it first
    if (self.pdfController) {
        [pdfController_ viewWillDisappear:NO];
        [pdfController_.view removeFromSuperview];
        [pdfController_ viewDidAppear:NO];
    }
    
        [self createPdfController];
    }
    
    // anyway, set document
    self.pdfController.document = document;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Split view

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

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    if (pageView.document) {
        // internally, pages start at 0. But be user-friendly and start at 1.
        self.title = [NSString stringWithFormat:@"%@ - Page %d", pageView.document.title, pageView.page + 1];    
    }else {
        self.title = @"No document loaded.";
        [self.pdfController setHUDVisible:NO animated:NO]; // ensure hud is disabled if no document is loaded.
    }
}

@end
