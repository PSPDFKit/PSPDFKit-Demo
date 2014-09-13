//
//  PSCSignAllPagesExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCFileHelper.h"
@import ObjectiveC.runtime;
#import "PSCExample.h"
@import Darwin.C.tgmath;

static const char PSCSignatureCompletionBlock;

@interface PSCSignAllPagesExample : PSCExample <PSPDFSignatureViewControllerDelegate> @end
@implementation PSCSignAllPagesExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Sign All Pages";
        self.contentDescription = @"Will add a signature (ink annotation) to all pages of a document, optionally flattened.";
        self.category = PSCExampleCategoryAnnotations;
        self.priority = 20;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    UIColor *penBlueColor = [UIColor colorWithRed:0.000f green:0.030f blue:0.516f alpha:1.000f];

    // Show the signature controller
    PSPDFSignatureViewController *signatureController = [[PSPDFSignatureViewController alloc] init];
    signatureController.drawView.strokeColor = penBlueColor;
    signatureController.drawView.lineWidth = 3.f;
    signatureController.delegate = self;
    UINavigationController *signatureContainer = [[UINavigationController alloc] initWithRootViewController:signatureController];
    signatureContainer.modalPresentationStyle = UIModalPresentationFormSheet;
    [delegate.currentViewController presentViewController:signatureContainer animated:YES completion:NULL];

    // To make the example more concise, we're using a callback block here.
    void(^signatureCompletionBlock)(PSPDFSignatureViewController *theSignatureController) = ^(PSPDFSignatureViewController *theSignatureController) {
        // Create the document.
        PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
        document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled; // Don't pollute other examples.

        // We want to add signture at the bottom of the page.
        for (NSUInteger pageIndex = 0; pageIndex < document.pageCount; pageIndex++) {

            // Check if we're already signed and ignore.
            BOOL alreadySigned = NO;
            NSArray *annotationsForPage = [document annotationsForPage:pageIndex type:PSPDFAnnotationTypeInk];
            for (PSPDFInkAnnotation *ann in annotationsForPage) {
                if ([ann.name isEqualToString:@"Signature"]) {
                    alreadySigned = YES; break;
                }
            }

            // Not yet signed -> create new Ink annotation.
            if (!alreadySigned) {
                const CGFloat margin = 10.f;
                const CGSize maxSize = CGSizeMake(150.f, 75.f);

                // Prepare the lines and convert them from view space to PDF space. (PDF space is mirrored!)
                PSPDFPageInfo *pageInfo = [document pageInfoForPage:pageIndex];
                NSArray *lines = PSPDFConvertViewLinesToPDFLines(signatureController.lines, pageInfo.rect, pageInfo.rotation, pageInfo.rect);

                // Calculate the size, aspect ratio correct.
                CGSize annotationSize = PSPDFBoundingBoxFromLines(lines, 2).size;
                CGFloat scale = PSCScaleForSizeWithinSize(annotationSize, maxSize);
                annotationSize = CGSizeMake(lround(annotationSize.width * scale), lround(annotationSize.height * scale));

                // Create the annotation.
                PSPDFInkAnnotation *annotation = [PSPDFInkAnnotation new];
                annotation.name = @"Signature"; // Arbitrary string, will be persisted in the PDF.
                annotation.lines = lines;
                annotation.lineWidth = 3.f;
                // Add lines to bottom right. (PDF zero is bottom left)
                annotation.boundingBox = CGRectMake(pageInfo.rect.size.width-annotationSize.width-margin, margin, annotationSize.width, annotationSize.height);
                annotation.color = penBlueColor;
                annotation.contents = [NSString stringWithFormat:@"Signed on %@ by test user.", [NSDateFormatter localizedStringFromDate:NSDate.date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle]];
                annotation.page = pageIndex;

                // Add annotation.
                [document addAnnotations:@[annotation] options:@{PSPDFAnnotationOptionUserCreatedKey: @YES}];
            }
        }

        // Now we could flatten the PDF so that the signature is "burned in".
        PSPDFAlertView *flattenAlert = [[PSPDFAlertView alloc] initWithTitle:@"Flatten Annotations" message:@"Flattening will merge the annotations with the page content"];
        [flattenAlert addButtonWithTitle:@"Flatten" block:^(NSInteger buttonIndex) {
            NSURL *tempURL = PSCTempFileURLWithPathExtension(@"flattened_signaturetest", @"pdf");
			PSPDFStatusHUDItem *status = [PSPDFStatusHUDItem progressWithText:[PSPDFLocalize(@"Preparing") stringByAppendingString:@"…"]];
			[status pushAnimated:YES];
            // Perform in background to allow progress showing.
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

                [PSPDFProcessor.defaultProcessor generatePDFFromDocument:document pageRanges:@[[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, document.pageCount)]] outputFileURL:tempURL options:@{PSPDFProcessorAnnotationTypes : @(PSPDFAnnotationTypeAll)} progressBlock:^(NSUInteger currentPage, NSUInteger numberOfProcessedPages, NSUInteger totalPages) {
                    dispatch_async(dispatch_get_main_queue(), ^{
						status.progress = (numberOfProcessedPages+1)/(float)totalPages;
					});
                } error:NULL];

                // completion
                dispatch_async(dispatch_get_main_queue(), ^{
					[status popAnimated:YES];
                    PSPDFDocument *flattenedDocument = [PSPDFDocument documentWithURL:tempURL];
                    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:flattenedDocument];
                    [delegate.currentViewController.navigationController pushViewController:pdfController animated:YES];
                });
            });
        }];
        [flattenAlert addButtonWithTitle:@"Allow Editing" block:^(NSInteger buttonIndex) {
            PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
            [delegate.currentViewController.navigationController pushViewController:pdfController animated:YES];
        }];
        [flattenAlert show];
    };

    objc_setAssociatedObject(signatureController, &PSCSignatureCompletionBlock, signatureCompletionBlock, OBJC_ASSOCIATION_COPY);
    return (UIViewController *)nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFSignatureViewControllerDelegate

// Sign all pages example
- (void)signatureViewControllerDidSave:(PSPDFSignatureViewController *)signatureController {
    [signatureController dismissViewControllerAnimated:YES completion:NULL];
    void(^signatureCompletionBlock)(PSPDFSignatureViewController *signatureController) = objc_getAssociatedObject(signatureController, &PSCSignatureCompletionBlock);
    if (signatureCompletionBlock) signatureCompletionBlock(signatureController);
}

- (void)signatureViewControllerDidCancel:(PSPDFSignatureViewController *)signatureController {
    [signatureController dismissViewControllerAnimated:YES completion:NULL];
}

@end
