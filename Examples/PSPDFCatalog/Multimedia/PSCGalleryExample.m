//
//  PSCGalleryExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCImageGalleryExample

@interface PSCImageGalleryExample : PSCExample @end
@implementation PSCImageGalleryExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Image Gallery";
        self.contentDescription = @"Gallery example with images.";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 50;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    
    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://localhost/Bundle/sample.gallery"];
    CGRect pageRect = [document pageInfoForPage:0].rotatedPageRect;
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    CGSize size = CGSizeMake(400, 300);
    galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
    [document addAnnotations:@[galleryAnnotation]];

    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCVideoGalleryExample

@interface PSCVideoGalleryExample : PSCExample @end
@implementation PSCVideoGalleryExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Image/Audio/Video/YouTube Gallery";
        self.contentDescription = @"Gallery example with video, images, audio and YouTube gallery items.";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 10;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://localhost/Bundle/video.gallery"];
    CGRect pageRect = [document pageInfoForPage:0].rotatedPageRect;
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    CGSize size = CGSizeMake(400, 300);
    galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
    [document addAnnotations:@[galleryAnnotation]];

    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomGalleryExample

@interface PSCCustomGalleryExample : PSCExample @end
@implementation PSCCustomGalleryExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Custom Gallery Example";
        self.contentDescription = @"Add animated gif or inline video.";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 200;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    // Set up the document.
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    document.editableAnnotationTypes = nil; // Diable annotation editing.

    // Get rects to position.
    UIImage *image = [UIImage imageNamed:@"mas_audio_b41570.gif"];
    CGSize imageSize = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.5f, 0.5f));
    CGRect pageRect = [document pageInfoForPage:0].rotatedPageRect;

    // Create tap action (open new popover with video in fullscreen)
    PSPDFURLAction *videoAction = [[PSPDFURLAction alloc] initWithURLString:@"http://movietrailers.apple.com/movies/wb/islandoflemurs/islandoflemurs-tlr1_480p.mov?width=848&height=480"];

    // Create action that opens a sheet.
    PSPDFURLAction *sheetVideoAction = [videoAction copy];
    sheetVideoAction.options = @{PSPDFActionOptionControls : @NO, // Disable browser controls.
                                 PSPDFActionOptionSize : [NSValue valueWithCGSize:CGSizeMake(620.f, 400.f)]}; // Will present as sheet on iPad, is ignored on iPhone.

    // First example - use a special link annotation.
    PSPDFLinkAnnotation *videoLink = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://localhost/Bundle/mas_audio_b41570.gif"];
    videoLink.boundingBox = CGRectMake(0.f, pageRect.size.height-imageSize.height-64.f, imageSize.width, imageSize.height);
    videoLink.controlsEnabled = NO; // Disable gallery touch processing.
    videoLink.action.nextAction = sheetVideoAction; // attach action after the image action.
    [document addAnnotations:@[videoLink]];


    // Second example - just add the video inline.
    // Notice the pspdfkit:// prefix that enables automatic video detection.
    PSPDFLinkAnnotation *videoEmbedded = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://movietrailers.apple.com/movies/wb/islandoflemurs/islandoflemurs-tlr1_480p.mov?width=848&height=480"];
    videoEmbedded.boundingBox = CGRectMake(pageRect.size.width-imageSize.width, pageRect.size.height-imageSize.height-64.f,
                                           imageSize.width, imageSize.height);
    [document addAnnotations:@[videoEmbedded]];

    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end
