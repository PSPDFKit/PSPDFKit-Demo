//
//  PSCShowHighlightNotesPDFController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCShowHighlightNotesPDFController.h"

@implementation PSCShowHighlightNotesPDFController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document configuration:(PSPDFConfiguration *)configuration {
    [super commonInitWithDocument:document configuration:configuration];
    self.delegate = self;

    // Add handler that notifies us when annotations are added and react accordingly.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(annotationsAddedNotification:) name:PSPDFAnnotationsAddedNotification object:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Notifications

- (void)annotationsAddedNotification:(NSNotification *)notification {
    for (PSPDFAnnotation *annotation in notification.object) {
        if (annotation.document == self.document && annotation.type == PSPDFAnnotationTypeHighlight) {
            PSPDFPageView *pageView = [self pageViewForPage:annotation.absolutePage];
            [pageView showNoteControllerForAnnotation:annotation showKeyboard:YES animated:YES];
            break;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

- (NSArray *)pdfViewController:(PSPDFViewController *)pdfController shouldShowMenuItems:(NSArray *)menuItems atSuggestedTargetRect:(CGRect)rect forAnnotations:(NSArray *)annotations inRect:(CGRect)annotationRect onPageView:(PSPDFPageView *)pageView {
    PSPDFAnnotation *annotation = annotations.count == 1 ? annotations.lastObject : nil;
    if (annotation.type == PSPDFAnnotationTypeHighlight) {
        // Show note controller directly, skipping the menu.
        [pageView showNoteControllerForAnnotation:annotation showKeyboard:NO animated:YES];
        return nil;
    } else {
        return menuItems;
    }
}

@end
