//
//  PSCCustomStampAnnotationsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "NSObject+PSCDeallocationBlock.h"
#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCCustomStampAnnotationsExample : PSCExample @end
@implementation PSCCustomStampAnnotationsExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Custom stamp annotations";
        self.contentDescription = @"Customizes the default set of stamps in the PSPDFStampViewController.";
        self.category = PSCExampleCategoryAnnotations;
        self.priority = 200;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    NSMutableArray *defaultStamps = [NSMutableArray array];
    for (NSString *stampSubject in @[@"Great!", @"Stamp", @"Like"]) {
        PSPDFStampAnnotation *stamp = [[PSPDFStampAnnotation alloc] initWithSubject:stampSubject];
        stamp.boundingBox = CGRectMake(0.f, 0.f, 200.f, 70.f);
        [defaultStamps addObject:stamp];
    }
    // Careful with memory - you don't wanna add large images here.
    PSPDFStampAnnotation *imageStamp = [[PSPDFStampAnnotation alloc] init];
    imageStamp.image = [UIImage imageNamed:@"exampleimage.jpg"];
    imageStamp.boundingBox = CGRectMake(0.f, 0.f, imageStamp.image.size.width/4.f, imageStamp.image.size.height/4.f);
    [defaultStamps addObject:imageStamp];
    [PSPDFStampViewController setDefaultStampAnnotations:defaultStamps];

    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.rightBarButtonItems = @[pdfController.annotationButtonItem];

    // Add cleanup block so other examples will use the default stamps.
    [pdfController psc_addDeallocBlock:^{
        [PSPDFStampViewController setDefaultStampAnnotations:nil];
    }];

    return pdfController;
}

@end
