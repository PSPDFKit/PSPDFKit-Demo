//
//  PSCChildViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCChildViewController.h"

@interface PSCChildViewController() <PSPDFViewControllerDelegate, UIToolbarDelegate>
@property (nonatomic, strong) PSPDFViewController *pdfController;
@property (nonatomic, strong) UIToolbar *toolbar;
@end

@implementation PSCChildViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithNibName:nil bundle:nil])) {
        _document = document;
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIViewController

- (void)createPDFViewController {
    // configure the PSPDF controller
    self.pdfController = [[PSPDFViewController alloc] initWithDocument:self.document];
    self.pdfController.pageTransition = PSPDFPageTransitionScrollContinuous;
    self.pdfController.scrollDirection = PSPDFScrollDirectionVertical;
    self.pdfController.fitToWidthEnabled = YES;
    self.pdfController.pagePadding = 0.f;
    self.pdfController.shadowEnabled = NO;
    self.pdfController.smartZoomEnabled = NO;
    self.pdfController.delegate = self;

    // Those need to be nilled out if you use the barButton items externally!
    self.pdfController.leftBarButtonItems = nil;
    self.pdfController.rightBarButtonItems = nil;

    // Also blocks code that is responsible for showing the HUD.
    self.pdfController.shouldHideNavigationBarWithHUD = NO;

    [self addChildViewController:self.pdfController];
    [self.pdfController didMoveToParentViewController:self];
    [self.view addSubview:self.pdfController.view];

    // As an example, here we're not using the UINavigationController but instead a custom UIToolbar.
    // Note that if you're going that way, you'll loose some features that PSPDFKit provides, like dynamic toolbar updating or accessibility.
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, 20.f, CGRectGetWidth(self.view.bounds), PSCToolbarHeightForOrientation(self.interfaceOrientation))];
    // Ensure we're top attached.
    toolbar.barTintColor = UIColor.pspdfColor;
    toolbar.delegate = self;
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.lightGrayColor;
    [self createPDFViewController];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
	// viewWillAppear: is too early for this, we need to hide the navBar here (UISearchDisplayController related issue)
	self.navigationController.navigationBarHidden = YES;
    // Center view with margins.
    self.pdfController.view.frame = CGRectInset(CGRectMake(0, self.toolbar.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.toolbar.bounds.size.height), 50.f, 50.f);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Manually unload view.
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

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIBarPositioningDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
