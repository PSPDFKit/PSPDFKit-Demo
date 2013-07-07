//
//  PSCShowHighlightNotesPDFController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCShowHighlightNotesPDFController.h"

@implementation PSCShowHighlightNotesPDFController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    self.delegate = self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forAnnotation:(PSPDFAnnotation *)annotation inRect:(CGRect)annotationRect onPageView:(PSPDFPageView *)pageView {
    if (annotation.type == PSPDFAnnotationTypeHighlight) {
        // Show note controller directly, skipping the menu.
        [pageView showNoteControllerForAnnotation:annotation showKeyboard:NO animated:YES];
        return nil;
    }else {
        return menuItems;
    }
}

@end
