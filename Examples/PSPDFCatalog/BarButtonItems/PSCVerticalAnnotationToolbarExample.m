//
//  PSCVerticalAnnotationToolbarExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCVerticalAnnotationToolbar.h"
#import "PSCExample.h

@interface PSCExampleAnnotationViewController : PSPDFViewController
@property (nonatomic, strong) PSCVerticalAnnotationToolbar *verticalToolbar;
@end

@interface PSCVerticalAnnotationToolbarExample : PSCExample @end
@implementation PSCVerticalAnnotationToolbarExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Vertical always-visible annotation bar";
        self.cont
        self.category = PSCExampleCategoryPDFAnnotations;
        self.priority = 30;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *controller = [[PSCExampleAnnotationViewController alloc] initWithDocument:document];
    return controller;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExampleAnnotationViewController

@implementation PSCExampleAnnotationViewController

- (void)dealloc {
    self.verticalToolbar.pdfController = nil; // ensure pdf controller is removed
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // create the custom toolbar and add it on top of the HUDView.
    self.verticalToolbar = [[PSCVerticalAnnotationToolbar alloc] initWithPDFController:self];
    self.verticalToolbar.frame = CGRectIntegral(CGRectMake(self.view.bounds.size.width-44.f, (self.view.bounds.size.height-44.f)/2, 44.f, 44.f * 2));
    self.verticalToolbar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.HUDView addSubview:self.verticalToolbar];
}

// ensure custom toolbar is hidden when we show the thumbnails
- (void)setViewMode:(PSPDFViewMode)viewMode animated:(BOOL)animated {
    [super setViewMode:viewMode animated:animated];

    [UIView animateWithDuration:0.25 delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.verticalToolbar.alpha = viewMode == PSPDFViewModeThumbnails ? 0.f : 1.f;
    } completion:NULL];
}

@end
