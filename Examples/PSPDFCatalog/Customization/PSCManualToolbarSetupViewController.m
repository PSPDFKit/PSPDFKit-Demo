//
//  PSCManualToolbarViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCManualToolbarSetupViewController.h"
#import "PSPDFFlexibleToolbarContainer.h"
#import "PSPDFFlexibleAnnotationToolbar.h"

@interface PSCManualToolbarSetupViewController () <UIToolbarDelegate, PSPDFFlexibleToolbarContainerDelegate>
@property (nonatomic, strong) PSPDFViewController *pdfController;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) PSPDFFlexibleToolbarContainer *flexibleToolbarContainer;
@end

@implementation PSCManualToolbarSetupViewController

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
	self.view.backgroundColor = [UIColor whiteColor];
    [self createPDFViewController];
}

- (void)createPDFViewController {
	// Add PSPDFViewController as a sub-controller
    self.pdfController = [[PSPDFViewController alloc] initWithDocument:self.document];
	self.pdfController.HUDViewMode = PSPDFHUDViewModeNever;
	self.pdfController.backgroundColor = [UIColor whiteColor];
	
	// Those need to be nilled out if you use the barButton items (e.g., annotationButtonItem) externally!
    self.pdfController.leftBarButtonItems = nil;
    self.pdfController.rightBarButtonItems = nil;
	
    [self addChildViewController:self.pdfController];
    [self.pdfController didMoveToParentViewController:self];
    [self.view addSubview:self.pdfController.view];
	
    // As an example, here we're not using the UINavigationController but instead a custom UIToolbar.
    // Note that if you're going that way, you'll loose some features that PSPDFKit provides, like dynamic toolbar updating or accessibility.
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.f, PSCIsUIKitFlatMode() ? 20.f : 0.f, CGRectGetWidth(self.view.bounds), PSCToolbarHeightForOrientation(self.interfaceOrientation))];
    // Ensure we're top attached. iOS 7 only feature.
	toolbar.delegate = self;
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	// Configure the toolbar items
    NSMutableArray *toolbarItems = [NSMutableArray array];
	toolbar.translucent = NO;
    [toolbarItems addObjectsFromArray:@[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonPressed:)], [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]]];
	
	// Normally we would just use the annotationButtonItem and let it do all the toolbar setup and management for us.
	// Here, however we'll show how one could manually configure and show the flexible annotation toolbar without using
	// PSPDFAnnotationBarButtonItem. Note that PSPDFAnnotationBarButtonItem handles quite a fiew more
	// cases and should in general be prefered to this simple toolbar setup.
	
    //if ([self.pdfController.annotationButtonItem isAvailableBlocking]) [toolbarItems addObject:self.pdfController.annotationButtonItem];
	
	// It's still a good idea to check if annotations are avaialble
	if ([self.pdfController.annotationButtonItem isAvailableBlocking]) [toolbarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(toggleToolbar:)]];
	
    toolbar.items = toolbarItems;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
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
#pragma mark - Annotation toolbar

- (void)toggleToolbar:(id)sender {
	if (self.flexibleToolbarContainer) [self.flexibleToolbarContainer hideAndRemoveAnimated:YES completion:nil];
	
	PSPDFAnnotationStateManager *manager = self.pdfController.annotationStateManager;
	PSPDFFlexibleAnnotationToolbar *toolbar = [[PSPDFFlexibleAnnotationToolbar alloc] initWithAnnotationStateManager:manager];
	[toolbar matchUIBarAppearance:self.toolbar]; // (optional)
	
	PSPDFFlexibleToolbarContainer *container = [[PSPDFFlexibleToolbarContainer alloc] initWithFrame:self.view.bounds];
	container.flexibleToolbar = toolbar;
	container.overlaidBar = self.toolbar;
	container.containerDelegate = self;
	[self.view addSubview:container];
    self.flexibleToolbarContainer = container;
	
	[container showAnimated:YES completion:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFFlexibleToolbarContainerDelegate

- (void)flexibleToolbarContainerDidHide:(PSPDFFlexibleToolbarContainer *)container {
	self.flexibleToolbarContainer = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
	// Position the pdfController content below the toolbar
	CGRect frame = self.view.bounds;
	frame.origin.y = CGRectGetMaxY(self.toolbar.frame);
	frame.size.height -= frame.origin.y;
    self.pdfController.view.frame = frame;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIBarPositioningDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
