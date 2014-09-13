//
//  PSCMultimediaExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCMultimediaPDFExample

@interface PSCMultimediaPDFExample : PSCExample @end
@implementation PSCMultimediaPDFExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Multimedia PDF example";
        self.contentDescription = @"Load PDF with various multimedia addititions and an embedded video.";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 10;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:@"multimedia.pdf"];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.rightBarButtonItems = @[pdfController.openInButtonItem, pdfController.viewModeButtonItem];
    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCMultimediaDynamicallyAddedVideoWithCoverExample

@interface PSCMultimediaDynamicallyAddedVideoWithCoverExample : PSCExample @end
@implementation PSCMultimediaDynamicallyAddedVideoWithCoverExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Dynamically added video with cover";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 500;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    // dynamically add video box
    [document.undoController performBlockWithoutUndo:^{
        PSPDFLinkAnnotation *videoLink = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://[autostart:false, cover:true]localhost/Bundle/big_buck_bunny.mp4"]];
        videoLink.boundingBox = CGRectInset([document pageInfoForPage:0].rotatedRect, 100.f, 100.f);
        [document addAnnotations:@[videoLink]];
    }];

    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

@interface PSCYoutubeGalleryExample : PSCExample @end
@implementation PSCYoutubeGalleryExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Embed YouTube video into a page";
        self.contentDescription = @"Embed a YouTube video directly on the page via PSPDFGallery.";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 40;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    // Dynamically add video box.
    [document.undoController performBlockWithoutUndo:^{
        PSPDFLinkAnnotation *video = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://youtube.com/embed/8B-y4idg700?VQ=HD720&start=10&end=20"]];
        video.boundingBox = CGRectMake(70.f, 150.f, 470.f, 270.f);
        [document addAnnotations:@[video]];
    }];

    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end
