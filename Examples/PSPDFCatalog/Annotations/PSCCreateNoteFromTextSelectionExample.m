//
//  PSCCreateNoteFromTextSelectionExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCCreateNoteFromTextSelectionExample.h"
#import "PSCAssetLoader.h"

@interface PSCCreateNoteFromTextSelectionExample () <PSPDFViewControllerDelegate>
@end

@implementation PSCCreateNoteFromTextSelectionExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Create Note from selected text";
        self.category = PSCExampleCategoryAnnotations;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    // Set up the document.
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:kHackerMagazineExample];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.delegate = self;
    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forSelectedText:(NSString *)selectedText inRect:(CGRect)textRect onPageView:(PSPDFPageView *)pageView {
    if (selectedText.length > 0) {
        PSPDFMenuItem *createNoteMenu = [[PSPDFMenuItem alloc] initWithTitle:@"Create Note" block:^{
            PSPDFNoteAnnotation *noteAnnotation = [PSPDFNoteAnnotation new];
            noteAnnotation.boundingBox = (CGRect){CGPointMake(CGRectGetMaxX(textRect), textRect.origin.y), PSPDFNoteAnnotationViewFixedSize};
            noteAnnotation.contents = selectedText;
            [pageView.document addAnnotations:@[noteAnnotation]];
            [pageView.selectionView discardSelection]; // clear text
            [pageView showNoteControllerForAnnotation:noteAnnotation showKeyboard:YES animated:YES]; // show popover
        }];
        return [menuItems arrayByAddingObjectsFromArray:@[createNoteMenu]];
    }else {
        return menuItems;
    }
}

@end
