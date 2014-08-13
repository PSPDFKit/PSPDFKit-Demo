//
//  PSCSimpleFontPickerExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"

@interface PSCSimpleFontPickerViewController : PSPDFFontPickerViewController @end

@interface PSCSimpleFontPickerExample : PSCExample <PSPDFViewControllerDelegate> @end
@implementation PSCSimpleFontPickerExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Simplified Font Picker";
        self.category = PSCExampleCategoryViewCustomization;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    // Create a sample annotation.
    PSPDFFreeTextAnnotation *freeText = [[PSPDFFreeTextAnnotation alloc] initWithContents:@"This is a test free-text annotation."];
    freeText.fillColor = UIColor.whiteColor;
    freeText.fontSize = 30.f;
    freeText.boundingBox = CGRectMake(300.f, 300.f, 150.f, 150.f);
    [freeText sizeToFit];
    [document addAnnotations:@[freeText]];

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    [pdfController overrideClass:PSPDFFontPickerViewController.class withClass:PSCSimpleFontPickerViewController.class];
    pdfController.delegate = self;
    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (void)pdfViewController:(PSPDFViewController *)pdfController didShowPageView:(PSPDFPageView *)pageView {
    // Just a convenience helper to automatically select the free text annotation.
    pageView.selectedAnnotations = [pdfController.document annotationsForPage:0 type:PSPDFAnnotationTypeFreeText];
    [pageView showMenuIfSelectedAnimated:YES];
}

@end

@implementation PSCSimpleFontPickerViewController

+ (NSArray *)allowedFonts {
    // Very strange, if Courier font isnt added Courier New wont appear
    return @[@"Arial", @"Calibri", @"Times New Roman", @"Courier New", @"Helvetica", @"Comic Sans MS"]; //, @"Courier"
}

+ (NSArray *)defaultBlocklist {
    NSArray *allAvailableFonts = [UIFont familyNames];

    NSMutableArray *newBlockList = [NSMutableArray array];
    NSArray *allowedFonts = [self allowedFonts];

    [allAvailableFonts enumerateObjectsUsingBlock:^(NSString *font, NSUInteger idx, BOOL *stop) {
        if (![allowedFonts containsObject:font]) {
            [newBlockList addObject:font];
        } else {
            NSLog(@"Font: %@", font);
        }
    }];

    return newBlockList;
}

- (BOOL)showDownloadableFonts {
    return NO;
}

- (BOOL)searchEnabled {
    return NO;
}

@end
