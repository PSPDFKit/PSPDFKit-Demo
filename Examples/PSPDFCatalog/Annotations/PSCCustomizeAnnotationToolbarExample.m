//
//  PSCCustomizeAnnotationToolbarExample.m
//  PSPDFCatalog-static
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "NSObject+PSCDeallocationBlock.h"
#import "PSCAssetLoader.h"
#import "PSCExample.h"

@interface PSCCustomizeAnnotationToolbarExample : PSCExample <PSPDFViewControllerDelegate> @end
@interface PSCCustomizedAnnotationToolbar : PSPDFAnnotationToolbar @end

@implementation PSCCustomizeAnnotationToolbarExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Customized Annotation Toolbar";
        self.contentDescription = @"Customizes the buttons in the annotation toolbar.";
        self.category = PSCExampleCategoryAnnotations;
        self.priority = 200;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:PSPDFHackerMagazineAsset];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document configuration:[PSPDFConfiguration configurationWithBuilder:^(PSPDFConfigurationBuilder *builder) {
        // Register the class overrides.
        [builder overrideClass:PSPDFAnnotationToolbar.class withClass:PSCCustomizedAnnotationToolbar.class];
    }]];
    pdfController.delegate = self;

    return pdfController;
}

@end

@implementation PSCCustomizedAnnotationToolbar

- (instancetype)initWithAnnotationStateManager:(PSPDFAnnotationStateManager *)annotationStateManager {
    if ((self = [super initWithAnnotationStateManager:annotationStateManager])) {
        if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSMutableArray *annotationGroups = [NSMutableArray arrayWithArray:self.annotationGroups];

            PSPDFAnnotationGroupItem *stampAnnotaion = [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringStamp];
            PSPDFAnnotationGroupItem *imageAnnotation = [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringImage];
            PSPDFAnnotationGroupItem *soundAnnotaion = [PSPDFAnnotationGroupItem itemWithType:PSPDFAnnotationStringSound];

            [annotationGroups replaceObjectAtIndex:6 withObject: [PSPDFAnnotationGroup groupWithItems:@[stampAnnotaion, imageAnnotation, soundAnnotaion]]];
            self.annotationGroups = annotationGroups;
        }
    }
    return self;
}

@end
