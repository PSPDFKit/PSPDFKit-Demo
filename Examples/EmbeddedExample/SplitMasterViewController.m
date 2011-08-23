//
//  SplitMasterViewController.m
//  EmbeddedExample
//
//  Created by Peter Steinberger on 8/22/11.
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import "SplitMasterViewController.h"

@interface SplitMasterViewController() 
@property(nonatomic, retain) PSPDFViewController *pdfController;
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@end

// note that it would be much better if we directly use PSPDFViewController,
// or reuse an embedded PSPDFViewController and modify the document via the .document property
// this technique is used to test fast creation/destroying of the viewController
@implementation SplitMasterViewController

@synthesize pdfController = pdfController_;
@synthesize masterPopoverController = masterPopoverController_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        self.title = @"Embedded PSPDFViewController";
    }
    return self;
}

- (void)dealloc {
    [masterPopoverController_ release];
    [pdfController_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)displayDocument:(PSPDFDocument *)document; {
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    } 
    
    // if controller is already displayed, destroy it first
    if (!self.pdfController) {
        [pdfController_ viewWillDisappear:NO];
        [pdfController_.view removeFromSuperview];
        [pdfController_ viewDidAppear:NO];
    }
    
    self.pdfController = [[[PSPDFViewController alloc] initWithDocument:document] autorelease];
    
    pdfController_.view.frame = self.view.bounds;
    [[pdfController_ view] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [pdfController_ setPageMode:PSPDFPageModeSingle];

    [pdfController_ viewWillAppear:NO];
    [self.view addSubview:pdfController_.view];
    [pdfController_ viewDidAppear:NO];
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

@end
