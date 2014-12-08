//
//  PSCThumbnailBarCellExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCCustomThumbnailCell : PSPDFThumbnailGridViewCell @end
@implementation PSCCustomThumbnailCell

- (void)updatePageLabel {
    [super updatePageLabel];

    // Set to top centered.
    self.pageLabel.frame = CGRectMake(10.f, 10.f, self.frame.size.width-20.f, self.pageLabel.frame.size.height);
}

@end

@interface PSCThumbnailBarCellExample : PSCExample @end
@implementation PSCThumbnailBarCellExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Custom Thumbnail Bar Cells";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 100;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        builder.thumbnailBarMode = PSPDFThumbnailBarModeScrollable;
        [builder overrideClass:PSPDFThumbnailGridViewCell.class withClass:PSCCustomThumbnailCell.class];
    }]];
    pdfController.HUDView.thumbnailBar.showPageLabels = YES;
    return pdfController;
}

@end
