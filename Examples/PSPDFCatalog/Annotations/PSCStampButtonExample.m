//
//  PSCStampButtonExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCStampButtonExample.h"
#import "PSCAssetLoader.h"

@interface PSCStampButtonExample () <PSPDFViewControllerDelegate>
@end

@implementation PSCStampButtonExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Stamp Annotation Button";
        self.contentDescription = @"Uses a stamp annotation as button.";
        self.category = PSCExampleCategoryPDFAnnotations;
        self.priority = 130;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    PSPDFStampAnnotation *imageStamp = [[PSPDFStampAnnotation alloc] init];
    imageStamp.image = [UIImage imageNamed:@"exampleimage.jpg"];
    imageStamp.boundingBox = CGRectMake(100.f, 100.f, imageStamp.image.size.width/4.f, imageStamp.image.size.height/4.f);

    imageStamp.page = 0;
    imageStamp.additionalActions = @{@(PSPDFAnnotationTriggerEventMouseDown) : [[PSPDFJavaScriptAction alloc] initWithScript:@""]};

    [document addAnnotations:@[imageStamp]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.delegate = self;
    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (BOOL)pdfViewController:(PSPDFViewController *)pdfController didTapOnAnnotation:(PSPDFAnnotation *)annotation annotationPoint:(CGPoint)annotationPoint annotationView:(UIView <PSPDFAnnotationViewProtocol> *)annotationView pageView:(PSPDFPageView *)pageView viewPoint:(CGPoint)viewPoint {

    [[[UIAlertView alloc] initWithTitle:@"Annotation tapped!" message:annotation.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    return YES; // mark as processed, else annotation might get selected.
}

@end
