//
//  PSCEmbeddedAnnotationTestViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCEmbeddedAnnotationTestViewController.h"

@implementation PSCEmbeddedAnnotationTestViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.delegate = self;
        document.delegate = self;
        self.renderingMode = PSPDFPageRenderingModeFullPageBlocking;

        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(saveAnnotations)];

        self.leftBarButtonItems = @[self.closeButtonItem, saveButton];

        if (PSIsIpad()) {
            self.rightBarButtonItems = @[self.annotationButtonItem, self.openInButtonItem, self.searchButtonItem, self.outlineButtonItem, self.viewModeButtonItem];
        }else {
            self.rightBarButtonItems = @[self.annotationButtonItem, self.openInButtonItem];
        }
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// Note: This is just an example how to explicitly force saving. PSPDFKit will do this automatically on various events (app background, view dismissal).
// Further you don't have to call reloadData after saving - this is done for testing the saving (since annotations that are not saved would disappear)
// If you want immediate saving after creating annotations either hook onto PSPDFAnnotationAddedNotification and PSPDFAnnotationChangedNotification or set saveAfterToolbarHiding to YES in PSPDFAnnotationToolbar (this will not be the same, but most of the time good enough).
- (void)saveAnnotations {
    NSLog(@"Annotations before saving: %@", [self.document annotationsForPage:0 type:PSPDFAnnotationTypeAll]);

    NSDictionary *dirtyAnnotations = [[self.document annotationParserForPage:0] dirtyAnnotations];
    NSLog(@"Dirty Annotations: %@", dirtyAnnotations);

    if (self.document.data) NSLog(@"Length of NSData before saving: %d", self.document.data.length);

    NSError *error = nil;
    if (![self.document saveChangedAnnotationsWithError:&error]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to save annotations.", @"") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil] show];
    }else {
        [self reloadData];
        NSLog(@"---------------------------------------------------");
        NSLog(@"Annotations after saving: %@", [self.document annotationsForPage:0 type:PSPDFAnnotationTypeAll]);
        //[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", @"") message:[NSString stringWithFormat:NSLocalizedString(@"Saved %d annotation(s)", @""), dirtyAnnotationCount] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil] show];

        if (self.document.data) NSLog(@"Length of NSData after saving: %d", self.document.data.length);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentDelegate

- (void)PDFDocument:(PSPDFDocument *)document didSaveAnnotations:(NSArray *)annotations {
    NSLog(@"Successfully saved annotations: %@", annotations);

    if (document.data) NSLog(@"This is your time to save the updated data!");
}

- (void)PDFDocument:(PSPDFDocument *)document failedToSaveAnnotations:(NSArray *)annotations error:(NSError *)error {
    NSLog(@"Failed to save annotations: %@", [error localizedDescription]);
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewControllerDelegate

// This is the default. Set to no to disable annotation selection.
- (BOOL)pdfViewController:(PSPDFViewController *)pdfController shouldSelectAnnotation:(PSPDFAnnotation *)annotation onPageView:(PSPDFPageView *)pageView {
    return YES;
}

@end
