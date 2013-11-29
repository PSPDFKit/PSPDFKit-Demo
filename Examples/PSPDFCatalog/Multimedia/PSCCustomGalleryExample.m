//
//  PSCCustomGalleryExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCCustomGalleryExample.h"
#import "PSCAssetLoader.h"

@interface PSCCustomGalleryViewController : PSPDFGalleryViewController
@end

@interface PSCCustomGalleryContentView : PSPDFGalleryContentView
@end

@interface PSCCustomGalleryImageContentView : PSPDFGalleryImageContentView
@end

@interface PSCCustomGalleryContentCaptionView : PSPDFGalleryContentCaptionView
@end

@implementation PSCCustomGalleryExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Custom Image Gallery";
        self.category = PSCExampleCategoryMultimedia;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    
    // Dynamically add gallery annotation.
    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfkit://localhost/Bundle/sample.gallery"];
    CGRect pageRect = [document pageInfoForPage:0].rotatedPageRect;
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    CGSize size = CGSizeMake(400, 300);
    galleryAnnotation.boundingBox = CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
    [document addAnnotations:@[galleryAnnotation]];
    
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    [pdfController overrideClass:PSPDFGalleryViewController.class withClass:PSCCustomGalleryViewController.class];
    
    // You need to override both, PSPDFGalleryContentView and PSPDFScrollableGalleryContentView
    // because both will be used.
    [pdfController overrideClass:PSPDFGalleryContentView.class withClass:PSCCustomGalleryContentView.class];
    [pdfController overrideClass:PSPDFGalleryImageContentView.class withClass:PSCCustomGalleryImageContentView.class];
    
    return pdfController;
}

@end

@implementation PSCCustomGalleryViewController

- (id)initWithLinkAnnotation:(PSPDFLinkAnnotation *)annotation {
    if ((self = [super initWithLinkAnnotation:annotation])) {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        self.fullscreenBackgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    }
    return self;
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

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.contentInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        self.backgroundColor = [UIColor clearColor];
        self.label.shadowColor = UIColor.blackColor;
    }
    return self;
}

@end
