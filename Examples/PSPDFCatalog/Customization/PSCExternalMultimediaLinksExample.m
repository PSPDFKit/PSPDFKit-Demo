//
//  PSCExternalMultimediaLinksExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

/**
 This example should illustrate how you can mix external annotations from a server with user annotations.
 Here we use the fact that it's quite uncommon for users to create link annotations, and we don't allow that anyway.
 */
@interface PSCExternalMultimediaLinksExample : PSCExample @end
@implementation PSCExternalMultimediaLinksExample

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Multimedia annotations and user annotations";
        self.category = PSCExampleCategoryViewCustomization;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];

    document.UID = @"multimedia_with_user_annotations"; // give it a unique ID so this example doesn't mix with others.
    document.annotationSaveMode = PSPDFAnnotationSaveModeExternalFile; // we want to save this into external storage.

    // Define an image gallery button (as link annotation)
    // Since link annotations are excluded by default in `saveableTypes` of the `PSPDFFileAnnotationProvider`,
    // this does not get saved (in your app, this might come from a server)
    PSPDFAction *action = [[PSPDFURLAction alloc] initWithURL:[NSURL URLWithString:@"pspdfkit://localhost/Bundle/sample.gallery"] options:@{PSPDFActionOptionButton : @YES}];
    PSPDFLinkAnnotation *galleryAnnotation = [[PSPDFLinkAnnotation alloc] initWithAction:action];
    galleryAnnotation.boundingBox = CGRectMake(arc4random_uniform(200), arc4random_uniform(200), 400.f, 300.f);
    [document addAnnotations:@[galleryAnnotation]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end
