//
//  PSCLockAnnotationsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"
#import "PSCFileHelper.h"

@interface PSCLockAnnotationsExample : PSCExample @end

@implementation PSCLockAnnotationsExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Generate a new file with locked annotations";
        self.contentDescription = @"Uses the annotation flags to create a locked copy.";
        self.category = PSCExampleCategoryAnnotations;
        self.priority = 199;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    // We use the same URL as in the "Write annotations into the PDF" example.

    // Original URL for the example file.
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *annotationSavingURL = [samplesURL URLByAppendingPathComponent:PSPDFHackerMagazineAsset];

    // Document-based URL (we use the changed file from "writing annotations into a file" for additional test annotations)
    NSURL *documentSamplesURL = PSCCopyFileURLToDocumentFolderAndOverride(annotationSavingURL, NO);

    // Target temp directory and copy file.
    NSURL *tempURL = PSCTempFileURLWithPathExtension([NSString stringWithFormat:@"locked_%@", documentSamplesURL.lastPathComponent], @"pdf");
    if ([NSFileManager.defaultManager fileExistsAtPath:documentSamplesURL.path]) {
        [NSFileManager.defaultManager copyItemAtURL:documentSamplesURL toURL:tempURL error:NULL];
    } else {
        [NSFileManager.defaultManager copyItemAtURL:annotationSavingURL toURL:tempURL error:NULL];
    }

    // Open the new file and modify the annotations to be locked.
    PSPDFDocument *document = [PSPDFDocument documentWithURL:tempURL];
    document.annotationSaveMode = PSPDFAnnotationSaveModeEmbedded;

    // Create at least one annotation if the document is currently empty.
    if ([document annotationsForPage:0 type:PSPDFAnnotationTypeAll&~PSPDFAnnotationTypeLink].count == 0) {
        PSPDFInkAnnotation *ink = [PSPDFInkAnnotation new];
        NSArray *lines = @[@[BOXED(CGPointMake(100,100)), BOXED(CGPointMake(100,200)), BOXED(CGPointMake(150,300))], // first line
                           @[BOXED(CGPointMake(200,100)), BOXED(CGPointMake(200,200)), BOXED(CGPointMake(250,300))]  // second line
                           ];
        PSPDFPageInfo *pageInfo = [document pageInfoForPage:0];
        ink.lineWidth = 5;
        ink.lines = PSPDFConvertViewLinesToPDFLines(lines, pageInfo.rect, pageInfo.rotation, UIScreen.mainScreen.bounds);
        ink.color = [UIColor colorWithRed:0.667f green:0.279f blue:0.748f alpha:1.f];
        ink.page = 0;
        [document addAnnotations:@[ink]];
    }

    // Lock all annotations except links and forms/widgets.
    for (NSUInteger pageIndex = 0; pageIndex < document.pageCount; pageIndex++) {
        NSArray *annotations = [document annotationsForPage:pageIndex type:PSPDFAnnotationTypeAll&~(PSPDFAnnotationTypeLink|PSPDFAnnotationTypeWidget)];
        for (PSPDFAnnotation *annotation in annotations) {
            // Preserve existing flags, just set locked + read only.
            annotation.flags |= PSPDFAnnotationFlagLocked;
        }
    }

    [document saveAnnotationsWithError:NULL];

    NSLog(@"Locked file: %@", tempURL.path);

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end
