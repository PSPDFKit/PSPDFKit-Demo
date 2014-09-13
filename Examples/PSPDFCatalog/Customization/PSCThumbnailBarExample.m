//
//  PSCThumbnailBarExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCThumbnailBarExample : PSCExample <PSPDFViewControllerDelegate> @end
@implementation PSCThumbnailBarExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Thumbnail Bar Example";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 999;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        builder.thumbnailBarMode = PSPDFThumbnailBarModeNone;
    }]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        pdfController.page = 15;
        [pdfController updateConfigurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
            builder.thumbnailBarMode = PSPDFThumbnailBarModeScrollable;
        }];
    });

    return pdfController;
}

@end
