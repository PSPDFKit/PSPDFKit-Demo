//
//  PSCOpenNoteOnPhoneWithSingleTapExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCOpenNoteOnPhoneWithSingleTapExample : PSCExample <PSPDFViewControllerDelegate> @end
@implementation PSCOpenNoteOnPhoneWithSingleTapExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Open Note with single tap on iPhone";
        self.category = PSCExampleCategoryViewCustomization;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.delegate = self;
    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forAnnotations:(NSArray *)annotations inRect:(CGRect)annotationRect onPageView:(PSPDFPageView *)pageView {

    // Modify the "Note..." menu item to auto-invoke.
    // Note: This is set to YES automatically on iPad.
    PSPDFAnnotation *firstAnnotation = annotations.firstObject;
    if (firstAnnotation.type == PSPDFAnnotationTypeNote && annotations.count == 1) {
        for (PSPDFMenuItem *menuItem in menuItems) {
            if ([menuItem.identifier isEqualToString:PSPDFAnnotationMenuNote]) {
                menuItem.shouldInvokeAutomatically = NO;
            }
        }
    }

    return menuItems;
}

@end
