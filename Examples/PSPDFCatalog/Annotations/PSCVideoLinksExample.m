//
//  PSCVideoLinksExample.m
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCVideoLinksExample.h"
#import "PSCAssetLoader.h"

@implementation PSCVideoLinksExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Video Link To Fullscreen";
        self.category = PSCExampleCategoryAnnotations;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
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


    // Third example - use a stamp annotation. This will be rendered into the PDF.
    // Add a link to a full-screen video.
    PSPDFStampAnnotation *videoStamp = [[PSPDFStampAnnotation alloc] initWithImage:[UIImage imageNamed:@"mas_audio_b41570.gif"]];

    // Center the image into the page in PDF coordinate space (flipped)
    videoStamp.boundingBox = CGRectMake((pageRect.size.width-imageSize.width)/2, 10.0f, imageSize.width, imageSize.height);

    // Add the video action and add the annotation.
    videoStamp.additionalActions = @{@(PSPDFAnnotationTriggerEventMouseDown) : videoAction};
    [document addAnnotations:@[videoStamp]];

    // Example using the new gallery (supports images, video, audio annotations)
    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://localhost/Bundle/video.gallery"];
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    
    CGSize size = CGSizeMake(400.0f, 225.0f);
    galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.f, center.y - size.height / 2.f, size.width, size.height);
    [document addAnnotations:@[galleryAnnotation]];

    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end
