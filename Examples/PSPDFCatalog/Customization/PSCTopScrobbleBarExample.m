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
@interface PSCCustomScrobbleBar : PSPDFScrobbleBar @end

@interface PSCTopScrobbleBarExample : PSCExample @end
@implementation PSCTopScrobbleBarExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Top Scrobble Bar";
        self.contentDescription = @"Shows how to change the scrobble bar frame.";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 400;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    [PSCCustomHUDView appearance].pageLabelDistance = 49.f;

    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        [builder overrideClass:PSPDFHUDView.class withClass:PSCCustomHUDView.class];

        // There's no need for actually overriding the scrobble bar in this example - it's just for testing.
        [builder overrideClass:PSPDFScrobbleBar.class withClass:PSCCustomScrobbleBar.class];
    }]];
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

@implementation PSCCustomScrobbleBar

- (instancetype)init {
    if ((self = [super init])) {
        NSLog(@"Using custom subclass");
    }
    return self;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCHUDViewGapExample

@interface PSCHUDGapPDFViewController : PSPDFViewController @end
@interface PSCHUDViewGapExample : PSCExample @end
@implementation PSCHUDViewGapExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Leave some bottom space for the HUD";
        self.contentDescription = @"Useful if you e.g. also have a UITabBar.";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 410;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
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
