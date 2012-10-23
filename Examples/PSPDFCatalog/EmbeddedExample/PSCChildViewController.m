//
//  PSCChildViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 PSPDFKit. All rights reserved.
//

#import "PSCChildViewController.h"
#import "PSCAppDelegate.h"

@interface PSCChildViewController() <PSPDFViewControllerDelegate>
@property (nonatomic, strong) PSPDFViewController *pdfController;
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
    self.pdfController = [[PSPDFViewController alloc] initWithDocument:nil];
    self.pdfController.pageTransition = PSPDFPageScrollContinuousTransition;
    self.pdfController.scrollDirection = PSPDFScrollDirectionVertical;
//    self.pdfController.renderingMode = PSPDFPageRenderingModeFullPageBlocking;
    self.pdfController.fitToWidthEnabled = YES;
    self.pdfController.toolbarEnabled = NO;
    self.pdfController.HUDViewMode = PSPDFHUDViewNever;
    self.pdfController.pagePadding = 0.f;
    self.pdfController.shadowEnabled = NO;
    self.pdfController.smartZoomEnabled = NO;
    self.pdfController.delegate = self;

    [self addChildViewController:self.pdfController];
    [self.pdfController didMoveToParentViewController:self];
    [self addChildViewController:self.pdfController];
    [self.view addSubview:self.pdfController.view];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    // center view with margins
    self.pdfController.view.frame = CGRectInset(self.view.bounds, 50, 50);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.pdfController.document = self.document;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // manually unload view.
    if ([self isViewLoaded] && !self.view.window) {
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

@end
