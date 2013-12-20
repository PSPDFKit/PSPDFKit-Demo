//
//  PSCCustomProtocolLinkExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCCustomProtocolLinkExample.h"
#import "PSCAssetLoader.h"

@implementation PSCCustomProtocolLinkExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Custom Link Protocol";
        self.category = PSCExampleCategoryPDFAnnotations;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFDocument *document = [PSCAssetLoader temporaryDocumentWithString:@"Test PDF for custom protocols"];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    // Add link
    // By default, PSPDFKit woud ask if you want to leave the app when an external URL is detected.
    // We skip this question if the protocol is defined within our own app.
    PSPDFLinkAnnotation *link = [[PSPDFLinkAnnotation alloc] initWithURLString:@"pspdfcatalog://this-is-a-test-link"];
    CGRect pageRect = [document pageInfoForPage:0].rotatedPageRect;
    CGPoint center = CGPointMake(CGRectGetMidX(pageRect), CGRectGetMidY(pageRect));
    CGSize size = CGSizeMake(400, 300);
    link.boundingBox = CGRectMake(center.x - size.width / 2.0f, center.y - size.height / 2.0f, size.width, size.height);
    [document addAnnotations:@[link]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end
