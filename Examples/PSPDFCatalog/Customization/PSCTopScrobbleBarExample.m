//
//  PSCTopScrobbleBarExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCTopScrobbleBarExample

@interface PSCCustomHUDView : PSPDFHUDView @end
@interface PSCTopScrobbleBarExample : PSCExample @end
@implementation PSCTopScrobbleBarExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Top Scrobble Bar";
        self.contentDescription = @"Shows how to change the scrobble bar frame.";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 400;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    [pdfController overrideClass:PSPDFHUDView.class withClass:PSCCustomHUDView.class];
    pdfController.pageLabelDistance = -pdfController.HUDView.scrobbleBar.scrobbleBarHeight + 5.f;
    return pdfController;
}

@end

@implementation PSCCustomHUDView

- (void)updateScrobbleBarFrameAnimated:(BOOL)animated {
    [super updateScrobbleBarFrameAnimated:animated];

    // Stick scrobble bar to the top.
    CGRect newFrame = self.dataSource.contentRect;
    newFrame.size.height = 44.f;
    self.scrobbleBar.frame = newFrame;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCHUDViewGapExample

@interface PSCHUDGapPDFViewController : PSPDFViewController @end
@interface PSCHUDViewGapExample : PSCExample @end
@implementation PSCHUDViewGapExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Leave some bottom space for the HUD";
        self.contentDescription = @"Useful if you e.g. also have a UITabBar.";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 410;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSCHUDGapPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end

@implementation PSCHUDGapPDFViewController

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGRect HUDFrame = self.view.bounds;
    HUDFrame.size.height -= 100.f;
    self.HUDView.frame = HUDFrame;
}

@end
