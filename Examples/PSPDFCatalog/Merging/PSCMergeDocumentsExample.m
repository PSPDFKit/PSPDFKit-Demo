//
//  PSCMergeDocumentsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCMergeDocumentsExample.h"
#import "PSCAssetLoader.h"
#import "PSCMergeDocumentsViewController.h"
#import "PSCFileHelper.h"

@implementation PSCMergeDocumentsExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if (self = [super init]) {
        self.title = @"Build a merge view to consolidate different document versions";
        self.category = PSCExampleCategoryAnnotations;
        self.targetDevice = PSCExampleTargetDeviceMaskPad;
    }
    return self;
}

- (UIViewController *)invoke {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *hackerPDFURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];
    NSURL *paperPDFURL = [samplesURL URLByAppendingPathComponent:kPaperExampleFileName];

    NSURL *originalPDF = PSCTempFileURLWithPathExtension(@"original", @"pdf");
    [NSFileManager.defaultManager copyItemAtURL:hackerPDFURL toURL:originalPDF error:NULL];

    NSURL *revisedPDF = PSCTempFileURLWithPathExtension(@"revised", @"pdf");
    [NSFileManager.defaultManager copyItemAtURL:paperPDFURL toURL:revisedPDF error:NULL];

    PSPDFDocument *document1 = [PSPDFDocument documentWithURL:revisedPDF];
    PSPDFDocument *document2 = [PSPDFDocument documentWithURL:originalPDF];

    UIViewController *mergeController = [[PSCMergeDocumentsViewController alloc] initWithLeftDocument:document1 rightDocument:document2];
    return mergeController;
}

@end
