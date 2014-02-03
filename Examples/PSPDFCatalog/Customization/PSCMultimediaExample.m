//
//  PSCMultimediaExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCMultimediaExample.h"
#import "PSCAssetLoader.h"

@implementation PSCMultimediaPDFExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Multimedia PDF example";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 10;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    PSPDFDocument *multimediaDoc = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"multimedia.pdf"]];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:multimediaDoc];
    pdfController.rightBarButtonItems = @[pdfController.openInButtonItem, pdfController.viewModeButtonItem];
    return pdfController;
}

@end

@implementation PSCMultimediaDynamicallyAddedVideoExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Dynamically added video example";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 20;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    PSPDFDocument *multimediaDoc = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
    multimediaDoc.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    
    // dynamically add video box
    PSPDFLinkAnnotation *aVideo = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://[autostart:false]localhost/Bundle/big_buck_bunny.mp4"];
    aVideo.boundingBox = CGRectInset([multimediaDoc pageInfoForPage:0].rotatedPageRect, 100, 100);
    [multimediaDoc addAnnotations:@[aVideo]];
    
    return [[PSPDFViewController alloc] initWithDocument:multimediaDoc];
}

@end

@implementation PSCMultimediaDynamicallyAddedVideoWithCoverExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Dynamically added video with cover";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 30;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    
    PSPDFDocument *multimediaDoc = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
    multimediaDoc.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    
    // dynamically add video box
    PSPDFLinkAnnotation *aVideo = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://[autostart:false, cover:true]localhost/Bundle/big_buck_bunny.mp4"];
    aVideo.boundingBox = CGRectInset([multimediaDoc pageInfoForPage:0].rotatedPageRect, 100, 100);
    [multimediaDoc addAnnotations:@[aVideo]];
    
    return [[PSPDFViewController alloc] initWithDocument:multimediaDoc];
}

@end

@implementation PSCYoutubeExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Add inline YouTube";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 40;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];

    PSPDFDocument *multimediaDoc = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];
    multimediaDoc.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    // dynamically add video box
    PSPDFLinkAnnotation *video = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://youtube.com/embed/8B-y4idg700?VQ=HD720"];
    video.boundingBox = CGRectMake(70.f, 150.f, 470.f, 270.f);
    [multimediaDoc addAnnotations:@[video]];

    return [[PSPDFViewController alloc] initWithDocument:multimediaDoc];
}

@end
