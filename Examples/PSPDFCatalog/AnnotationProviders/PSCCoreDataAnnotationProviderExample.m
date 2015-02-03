//
//  PSCCoreDataAnnotationProviderExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCCoreDataAnnotationProvider.h"
#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCCoreDataAnnotationProviderExample : PSCExample @end
@implementation PSCCoreDataAnnotationProviderExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Core Data Annotation Provider";
        self.contentDescription = @"Annotations can be saved via Core Data. This works, but we are recommending XFDF as a faster, standard compliment alternative.";
        self.category = PSCExampleCategoryAnnotationProviders;
        self.priority = 10;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:@"A.pdf"];
    // Set annotation provider block.
    [document setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
        PSCCoreDataAnnotationProvider *provider = [[PSCCoreDataAnnotationProvider alloc] initWithDocumentProvider:documentProvider databasePath:nil];
        documentProvider.annotationManager.annotationProviders = @[provider];
    }];
    // Create controller.
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end
