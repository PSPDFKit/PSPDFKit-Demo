//
//  PSCSimpleAudioGalleryExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCSimpleAudioGalleryExample : PSCExample @end
@implementation PSCSimpleAudioGalleryExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Simple Audio Annotation";
        self.contentDescription = @"Add an mp3 to the PDF.";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 500;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader temporaryDocumentWithString:@"Test PDF"];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    // Dynamically add gallery annotation.
    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://[type:audio]http://api.soundcloud.com/tracks/82065282/download?client_id=20e3de80e29b918c89e5000a8489cc27"]];
    CGRect pageRect = [document pageInfoForPage:0].rotatedRect;
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    CGSize size = CGSizeMake(400.f, 100.f);
    galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.f, center.y - size.height / 2.f, size.width, size.height);
    [document addAnnotations:@[galleryAnnotation]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end
