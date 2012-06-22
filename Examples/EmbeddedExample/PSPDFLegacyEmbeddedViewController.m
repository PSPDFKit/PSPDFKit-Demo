//
//  PSPDFLegacyEmbeddedViewController.m
//  EmbeddedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFLegacyEmbeddedViewController.h"

@implementation PSPDFLegacyEmbeddedViewController

@synthesize pdfController = _pdfController;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(closeModalController)];
    }
    return self;
}

- (void)closeModalController {
    [self dismissModalViewControllerAnimated:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
    NSString *documentFolder = [paths objectAtIndex:0];
    NSString *path = [documentFolder stringByAppendingPathComponent:@"PSPDFKit.pdf"];
    PSPDFDocument *document = [PSPDFDocument PDFDocumentWithUrl:[NSURL fileURLWithPath:path]];
    self.pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    self.pdfController.statusBarStyleSetting = PSPDFStatusBarInherit;
    self.pdfController.pageMode = PSPDFPageModeSingle;
    self.pdfController.linkAction = PSPDFLinkActionInlineBrowser;
    self.pdfController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.pdfController.view.frame = CGRectMake(120, 150, self.view.frame.size.width - 120*2, PSIsIpad() ? 500 : 200);
    [self.view addSubview:self.pdfController.view];

    // add a border
    self.pdfController.view.layer.borderColor = [UIColor blackColor].CGColor;
    self.pdfController.view.layer.borderWidth = 2.f;
}

// replaces viewDidUnload as this is deprecated on iOS6.
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if (![self isViewLoaded]) {
        // remove subcontroller
        [self.pdfController viewWillDisappear:NO];
        [self.pdfController.view removeFromSuperview];
        [self.pdfController viewDidDisappear:NO];
        self.pdfController = nil;
    }
}

// Note: You REALLY wanna use the iOS5 containment embedding,
// but this can be used if you still need to support iOS4.

// relay appearance events
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

// relay rotation events
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.pdfController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.pdfController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self.pdfController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return PSIsIpad() ? YES : toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

@end
