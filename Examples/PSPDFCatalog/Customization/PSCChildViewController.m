//
//  PSCChildViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSCChildViewController.h"
#import "PSCAppDelegate.h"

@interface PSCChildViewController() <PSPDFViewControllerDelegate>
@property (nonatomic, strong) PSPDFViewController *pdfController;
@property (nonatomic, strong) UIToolbar *toolbar;
@end

@implementation PSCChildViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _document = document;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // configure the PSPDF controller
    self.pdfController = [[PSPDFViewController alloc] initWithDocument:self.document];
    self.pdfController.pageTransition = PSPDFPageScrollContinuousTransition;
    self.pdfController.scrollDirection = PSPDFScrollDirectionVertical;
    self.pdfController.fitToWidthEnabled = YES;
    //self.pdfController.toolbarEnabled = NO;
    //self.pdfController.HUDViewMode = PSPDFHUDViewNever;
    self.pdfController.pagePadding = 0.f;
    self.pdfController.shadowEnabled = NO;
    self.pdfController.smartZoomEnabled = NO;
    self.pdfController.delegate = self;
    [self addChildViewController:self.pdfController];
    [self.pdfController didMoveToParentViewController:self];
    [self.view addSubview:self.pdfController.view];

    // As an example, here we're not using the UINavigationController but instead a custom UIToolbar.
    // Note that if you're going that way, you'll loose some features that PSPDFKit provides, like dynamic toolbar updating or accessibility.
    self.navigationController.navigationBarHidden = YES;
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), PSPDFToolbarHeightForOrientation(self.interfaceOrientation))];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpace.width = 8;
    
    NSMutableArray *toolbarItems = [NSMutableArray array];
    [toolbarItems addObjectsFromArray:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)], flexibleSpace, self.pdfController.searchButtonItem]];

    if ([self.pdfController.outlineButtonItem isAvailableBlocking]) [toolbarItems addObjectsFromArray:@[fixedSpace, self.pdfController.outlineButtonItem]];
    if ([self.pdfController.annotationButtonItem isAvailableBlocking]) [toolbarItems addObjectsFromArray:@[fixedSpace, self.pdfController.annotationButtonItem]];
    [toolbarItems addObjectsFromArray:@[fixedSpace, self.pdfController.bookmarkButtonItem]];

    toolbar.items = toolbarItems;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // center view with margins
    self.pdfController.view.frame = CGRectInset(CGRectMake(0, self.toolbar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.toolbar.bounds.size.height), 50, 50);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // manually unload view.
    if (self.isViewLoaded && !self.view.window) {
        [self.pdfController willMoveToParentViewController:nil];
        [self.pdfController.view removeFromSuperview];
        [self.pdfController removeFromParentViewController];
        self.pdfController = nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)setDocument:(PSPDFDocument *)document {
    if (document != _document) {
        _document = document;
        self.pdfController.document = document;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)doneButtonPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
