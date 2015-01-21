//
//  PSCVerticalAnnotationToolbarExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCVerticalAnnotationToolbar.h"
#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCExampleAnnotationViewController : PSPDFViewController
@property (nonatomic, strong) PSCVerticalAnnotationToolbar *verticalToolbar;
@end

@interface PSCVerticalAnnotationToolbarExample : PSCExample @end
@implementation PSCVerticalAnnotationToolbarExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Vertical always-visible annotation bar";
        self.contentDescription = @"Custom, vertically aligned annotation toolbar.";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 30;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    PSPDFViewController *controller = [[PSCExampleAnnotationViewController alloc] initWithDocument:document];
	// Remove the default annotationBarButtonItem
	NSMutableArray *items = [controller.rightBarButtonItems mutableCopy];
	[items removeObject:controller.annotationButtonItem];
	controller.rightBarButtonItems = items;
    return controller;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExampleAnnotationViewController

@implementation PSCExampleAnnotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // create the custom toolbar and add it on top of the HUDView.
    self.verticalToolbar = [[PSCVerticalAnnotationToolbar alloc] initWithAnnotationStateManager:self.annotationStateManager];
    self.verticalToolbar.frame = CGRectIntegral(CGRectMake(self.view.bounds.size.width-44.f, (self.view.bounds.size.height-44.f)/2, 44.f, 44.f * 2));
    self.verticalToolbar.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    [self.HUDView addSubview:self.verticalToolbar];
}

- (void)setViewMode:(PSPDFViewMode)viewMode animated:(BOOL)animated {
    [super setViewMode:viewMode animated:animated];
	// ensure custom toolbar is hidden when we show the thumbnails
    [UIView animateWithDuration:0.25 delay:0.f options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.verticalToolbar.alpha = viewMode == PSPDFViewModeThumbnails ? 0.f : 1.f;
    } completion:NULL];
}

@end
