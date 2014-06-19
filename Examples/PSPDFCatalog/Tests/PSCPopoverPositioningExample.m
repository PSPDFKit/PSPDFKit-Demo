//
//  PSCPopoverPositioningExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCAssetLoader.h"
#import "PSCExample.h"
#import "UIColor+PSPDFCatalog.h"

@interface PSCPopoverPositioningExample : PSCExample @end
@implementation PSCPopoverPositioningExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Popover positioning Tests";
        self.category = PSCExampleCategoryTests;
        self.priority = 1;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:kHackerMagazineExample]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:pdfController];

    UIViewController *dummyController = [[UIViewController alloc] init];
    [dummyController addChildViewController:navController];
    navController.view.frame = CGRectMake(100.f, 100.f, 500.f, 500.f);
    [dummyController.view addSubview:navController.view];
    [pdfController didMoveToParentViewController:navController];

    return dummyController;
}

@end
