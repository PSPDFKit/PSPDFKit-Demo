//
//  PSCMergeDocumentsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCMergeDocumentsViewController.h"
#import "PSCFileHelper.h"
#import "PSCCoreDataAnnotationProvider.h"
#import "PSCExample.h"

#define PSCCoreDataAnnotationProviderEnabled

@interface PSCMergeDocumentsExample : PSCExample @end
@implementation PSCMergeDocumentsExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Merge Annotations Interface";
        self.contentDescription = @"Proof-of-concept interface that shows two document side-by-side and allows to copy/merge annotations to the target document.";
        self.category = PSCExampleCategoryAnnotations;
        self.targetDevice = PSCExampleTargetDeviceMaskPad;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *hackerPDFURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];
    NSURL *paperPDFURL = [samplesURL URLByAppendingPathComponent:kPaperExampleFileName];


    NSURL *originalPDF = PSCCopyFileURLToDocumentFolderAndOverride(hackerPDFURL, NO);
    [NSFileManager.defaultManager copyItemAtURL:hackerPDFURL toURL:originalPDF error:NULL];

    NSURL *revisedPDF = PSCCopyFileURLToDocumentFolderAndOverride(paperPDFURL, NO);
    [NSFileManager.defaultManager copyItemAtURL:paperPDFURL toURL:revisedPDF error:NULL];

    PSPDFDocument *document1 = [PSPDFDocument documentWithURL:revisedPDF];
    PSPDFDocument *document2 = [PSPDFDocument documentWithURL:originalPDF];

    // As an additional example, here's the blueprint how to use the same with custom annotation providers
#ifdef PSCCoreDataAnnotationProviderEnabled
    document2.undoEnabled = NO;
    [document2 setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
        PSCCoreDataAnnotationProvider *provider = [[PSCCoreDataAnnotationProvider alloc] initWithDocumentProvider:documentProvider databasePath:nil];
        documentProvider.annotationManager.annotationProviders = @[provider];
    }];
#endif

    UIViewController *mergeController = [[PSCMergeDocumentsViewController alloc] initWithLeftDocument:document1 rightDocument:document2];
    return mergeController;
}

@end
