//
//  PSCGalleryExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCGalleryExampleCustomEmbeddedBackgroundView : PSPDFGalleryEmbeddedBackgroundView @end
@implementation PSCGalleryExampleCustomEmbeddedBackgroundView @end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCImageGalleryExample

@interface PSCImageGalleryExample : PSCExample <PSPDFViewControllerDelegate> @end
@implementation PSCImageGalleryExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Image Gallery";
        self.contentDescription = @"Gallery example with images.";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 50;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://localhost/Bundle/sample.gallery"]];
    CGRect pageRect = [document pageInfoForPage:0].rotatedRect;
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    CGSize size = CGSizeMake(400.f, 300.f);
    galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
    [document addAnnotations:@[galleryAnnotation]];

    // Customize.
    [[PSCGalleryExampleCustomEmbeddedBackgroundView appearance] setBlurEnabledObject:@YES];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        [builder overrideClass:PSPDFGalleryEmbeddedBackgroundView.class withClass:PSCGalleryExampleCustomEmbeddedBackgroundView.class.class];
    }]];
    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCButtonImageGalleryExample

@interface PSCButtonImageGalleryExample : PSCExample <PSPDFViewControllerDelegate> @end
@implementation PSCButtonImageGalleryExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Image Gallery with button activation";
        self.contentDescription = @"Buttons that show/hide the gallery or videos.";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 51;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader temporaryDocumentWithString:@"Image Gallery with Buttons Example"];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    document.editableAnnotationTypes = nil; // disable free text editing here as we use them as labels.

    {
        PSPDFFreeTextAnnotation *galleryText = [[PSPDFFreeTextAnnotation alloc] initWithContents:@"Gallery that opens inline\nPSPDFActionOptionButton : @YES"];
        galleryText.boundingBox = CGRectMake(20.f, 700.f, galleryText.boundingBox.size.width, galleryText.boundingBox.size.height);

        // @{PSPDFActionOptionButton : @"pspdfkit://localhost/Bundle/eye.png"};
        // Setting the button option to yes will show the default button.
        PSPDFURLAction *galleryAction = [[PSPDFURLAction alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://localhost/Bundle/sample.gallery"] options:@{PSPDFActionOptionButton : @YES}];
        PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithAction:galleryAction];
        galleryAnnotation.boundingBox = CGRectMake(200.f, 560.f, 400.f, 300.f);
        [document addAnnotations:@[galleryText, galleryAnnotation]];
    }

    {
        PSPDFFreeTextAnnotation *galleryText = [[PSPDFFreeTextAnnotation alloc] initWithContents:@"Gallery that opens inline with a custom button image\nPSPDFActionOptionButton : @\"http://cl.ly/image/2W1d020O1N2g/webimage2@2x.png\""];
        galleryText.boundingBox = CGRectMake(20.f, 400.f, galleryText.boundingBox.size.width, galleryText.boundingBox.size.height);

        // Setting the button option to an URL will load this URL. The URL can be local or remote. Use pspdfkit://localhost for local URLs.
        PSPDFAction *action = [[PSPDFURLAction alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://localhost/Bundle/sample.gallery"] options:@{PSPDFActionOptionButton : @"http://cl.ly/image/1h2N1r333N0V/webimage2@2x.png"}];
        PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithAction:action];
        galleryAnnotation.boundingBox = CGRectMake(200.f, 350.f, 250.f, 200.f);
        [document addAnnotations:@[galleryText, galleryAnnotation]];
    }

    {
        PSPDFFreeTextAnnotation *webText = [[PSPDFFreeTextAnnotation alloc] initWithContents:@"Link that opens modally.\nPSPDFActionOptionButton : @YES,\nPSPDFActionOptionModal : @YES,\nPSPDFActionOptionSize : BOXED(CGSizeMake(550.f, 550.f)"];
        webText.boundingBox = CGRectMake(20.f, 100.f, webText.boundingBox.size.width, webText.boundingBox.size.height);

        PSPDFAction *action = [[PSPDFURLAction alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://www.apple.com/ipad/"] options:@{PSPDFActionOptionButton : @YES, PSPDFActionOptionModal : @YES, PSPDFActionOptionSize : BOXED(CGSizeMake(550.f, 550.f))}];
        PSPDFLinkAnnotation *webAnnotation = [[PSPDFLinkAnnotation alloc] initWithAction:action];
        webAnnotation.boundingBox = CGRectMake(200.f, 100.f, 200.f, 200.f);
        [document addAnnotations:@[webText, webAnnotation]];
    }

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        [builder overrideClass:PSPDFGalleryEmbeddedBackgroundView.class withClass:PSCGalleryExampleCustomEmbeddedBackgroundView.class.class];
    }]];
    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCVideoGalleryExample

@interface PSCVideoGalleryExample : PSCExample @end
@implementation PSCVideoGalleryExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Image/Audio/Video/YouTube Gallery";
        self.contentDescription = @"Gallery example with video, images, audio and YouTube gallery items.";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 10;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://localhost/Bundle/video.gallery"]];
    CGRect pageRect = [document pageInfoForPage:0].rotatedRect;
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    CGSize size = CGSizeMake(400.f, 300.f);
    galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
    [document addAnnotations:@[galleryAnnotation]];

    PSPDFLinkAnnotation *galleryAnnotation2 = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://localhost/Bundle/video.gallery"]];
    galleryAnnotation2.boundingBox = CGRectMake(50.f, 50.f, 150.f, 150.f);
    [document addAnnotations:@[galleryAnnotation2]];

    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCCustomGalleryExample

@interface PSCCustomGalleryExample : PSCExample @end
@implementation PSCCustomGalleryExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Custom Gallery Example";
        self.contentDescription = @"Add animated gif or inline video.";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 200;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    // Set up the document.
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    document.editableAnnotationTypes = nil; // Diable annotation editing.

    // Get rects to position.
    UIImage *image = [UIImage imageNamed:@"mas_audio_b41570.gif"];
    CGSize imageSize = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(0.5f, 0.5f));
    CGRect pageRect = [document pageInfoForPage:0].rotatedRect;

    // Create tap action (open new popover with video in fullscreen)
    PSPDFURLAction *videoAction = [[PSPDFURLAction alloc] initWithURLString:@"http://movietrailers.apple.com/movies/wb/islandoflemurs/islandoflemurs-tlr1_480p.mov?width=848&height=480"];

    // Create action that opens a sheet.
    NSDictionary *options = @{
        // Disable browser controls.
        PSPDFActionOptionControls: @NO,
        // Will present as sheet on iPad, is ignored on iPhone.
        PSPDFActionOptionSize: [NSValue valueWithCGSize:CGSizeMake(620.f, 400.f)]
    };
    PSPDFURLAction *sheetVideoAction = [[PSPDFURLAction alloc] initWithURL:videoAction.URL options:options];

    // First example - use a special link annotation.
    PSPDFLinkAnnotation *videoLink = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://localhost/Bundle/mas_audio_b41570.gif"]];
    videoLink.boundingBox = CGRectMake(0.f, pageRect.size.height-imageSize.height-64.f, imageSize.width, imageSize.height);
    videoLink.controlsEnabled = NO; // Disable gallery touch processing.
    videoLink.action.nextAction = sheetVideoAction; // attach action after the image action.
    [document addAnnotations:@[videoLink]];


    // Second example - just add the video inline.
    // Notice the pspdfkit:// prefix that enables automatic video detection.
    PSPDFLinkAnnotation *videoEmbedded = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://movietrailers.apple.com/movies/wb/islandoflemurs/islandoflemurs-tlr1_480p.mov?width=848&height=480"]];
    videoEmbedded.boundingBox = CGRectMake(pageRect.size.width-imageSize.width, pageRect.size.height-imageSize.height-64.f,
                                           imageSize.width, imageSize.height);
    [document addAnnotations:@[videoEmbedded]];

    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCPopoverGalleryExample

@interface PSCPopoverGalleryExample : PSCExample @end
@implementation PSCPopoverGalleryExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Popover Gallery Example";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 200;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    
    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://[popover:1,size:50x50]localhost/Bundle/sample.gallery"]];
    CGRect pageRect = [document pageInfoForPage:0].rotatedRect;
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    CGSize size = CGSizeMake(400.f, 300.f);
    galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
    [document addAnnotations:@[galleryAnnotation]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCHighResImageGalleryExample

@interface PSCHighResImageGalleryExample : PSCExample @end
@implementation PSCHighResImageGalleryExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"High-Resolution Image Gallery Example";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 200;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    
    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://localhost/Bundle/highres.gallery"]];
    CGRect pageRect = [document pageInfoForPage:0].rotatedRect;
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    CGSize size = CGSizeMake(400.f, 300.f);
    galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
    [document addAnnotations:@[galleryAnnotation]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCHiddenSoundGalleryExample

@interface PSCHiddenSoundGalleryExample : PSCExample @end
@implementation PSCHiddenSoundGalleryExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Hidden Sound Annotation";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 200;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://localhost/Bundle/NightOwl.m4a"]];
    galleryAnnotation.autoplayEnabled = YES;
    galleryAnnotation.loopEnabled = YES;
    galleryAnnotation.flags = PSPDFAnnotationFlagHidden;
    CGRect pageRect = [document pageInfoForPage:0].rotatedRect;
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    CGSize size = CGSizeMake(400.f, 300.f);
    galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
    [document addAnnotations:@[galleryAnnotation]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end
