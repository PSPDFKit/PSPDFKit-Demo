//
//  PSCCustomGalleryExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCCustomGalleryBackgroundExample : PSCExample @end

@interface PSCCustomGalleryContentView : PSPDFGalleryContentView @end
@interface PSCCustomGalleryImageContentView : PSPDFGalleryImageContentView @end
@interface PSCCustomGalleryContentCaptionView : PSPDFGalleryContentCaptionView @end
@interface PSCCustomGalleryEmbeddedBackgroundView : PSPDFGalleryEmbeddedBackgroundView @end
@interface PSCCustomGalleryFullscreenBackgroundView : PSPDFGalleryFullscreenBackgroundView @end

@implementation PSCCustomGalleryBackgroundExample

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Custom Image Gallery Background";
        self.contentDescription = @"Changes internal gallery classes to customize the default background gradient.";
        self.category = PSCExampleCategoryMultimedia;
        self.priority = 100;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    // Dynamically add gallery annotation.
    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://localhost/Bundle/sample.gallery"];
    CGRect pageRect = [document pageInfoForPage:0].rotatedRect;
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    CGSize size = CGSizeMake(400.f, 300.f);
    galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.f, center.y - size.height / 2.f, size.width, size.height);
    [document addAnnotations:@[galleryAnnotation]];

    [[PSCCustomGalleryEmbeddedBackgroundView appearance] setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
    [[PSCCustomGalleryFullscreenBackgroundView appearance] setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

    // You need to override both, PSPDFGalleryContentView and PSPDFScrollableGalleryContentView - both will be used.
    [pdfController overrideClass:PSPDFGalleryContentView.class withClass:PSCCustomGalleryContentView.class];
    [pdfController overrideClass:PSPDFGalleryImageContentView.class withClass:PSCCustomGalleryImageContentView.class];
    [pdfController overrideClass:PSPDFGalleryEmbeddedBackgroundView.class withClass:PSCCustomGalleryEmbeddedBackgroundView.class];
    [pdfController overrideClass:PSPDFGalleryFullscreenBackgroundView.class withClass:PSCCustomGalleryFullscreenBackgroundView.class];

    return pdfController;
}

@end

@implementation PSCCustomGalleryImageContentView

+ (Class)captionViewClass {
    return [PSCCustomGalleryContentCaptionView class];
}

@end

@implementation PSCCustomGalleryContentView

+ (Class)captionViewClass {
    return [PSCCustomGalleryContentCaptionView class];
}

@end

@implementation PSCCustomGalleryContentCaptionView

+ (Class)layerClass {
    // Disable gradient background.
    return [CALayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.contentInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        self.backgroundColor = [UIColor clearColor];
        self.label.shadowColor = UIColor.blackColor;
    }
    return self;
}

@end

@implementation PSCCustomGalleryEmbeddedBackgroundView @end
@implementation PSCCustomGalleryFullscreenBackgroundView @end
