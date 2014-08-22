//
//  PSCEmbeddedAnnotationTestViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCEmbeddedAnnotationTestViewController.h"

@implementation PSCEmbeddedAnnotationTestViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.delegate = self;
        document.delegate = self;
        self.renderingMode = PSPDFPageRenderingModeFullPageBlocking;

        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(saveAnnotations)];

        self.leftBarButtonItems = @[self.closeButtonItem, saveButton];

        if (PSCIsIPad()) {
            self.rightBarButtonItems = @[self.annotationButtonItem, self.openInButtonItem, self.searchButtonItem, self.outlineButtonItem, self.viewModeButtonItem];
        }else {
            self.rightBarButtonItems = @[self.annotationButtonItem, self.openInButtonItem, self.viewModeButtonItem];
        }
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

// Note: This is just an example how to explicitly force saving. PSPDFKit will do this automatically on various events (app background, view dismissal).
// Further you don't have to call reloadData after saving - this is done for testing the saving (since annotations that are not saved would disappear)
// If you want immediate saving after creating annotations either hook onto PSPDFAnnotationsAddedNotification and PSPDFAnnotationChangedNotification or set saveAfterToolbarHiding to YES in PSPDFFlexibleAnnotationToolbar (this will not be the same, but most of the time good enough).
- (void)saveAnnotations {
    //NSLog(@"Annotations before saving: %@", [self.document annotationsForPage:0 type:PSPDFAnnotationTypeAll]);

    NSDictionary *dirtyAnnotations = [[self.document annotationManagerForPage:0] dirtyAnnotations];
    NSLog(@"Dirty Annotations: %@", dirtyAnnotations);

    if (self.document.data) NSLog(@"Length of NSData before saving: %tu", self.document.data.length);

    NSError *error = nil;
    if (![self.document saveAnnotationsWithError:&error]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to save annotations", @"") message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil] show];
    }else {
        [self reloadData];
        NSLog(@"---------------------------------------------------");
        //NSLog(@"Annotations after saving: %@", [self.document annotationsForPage:0 type:PSPDFAnnotationTypeAll]);
        //[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", @"") message:[NSString stringWithFormat:NSLocalizedString(@"Saved %d annotation(s)", @""), dirtyAnnotationCount] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil] show];

        if (self.document.data) NSLog(@"Length of NSData after saving: %tu", self.document.data.length);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentDelegate

- (void)pdfDocument:(PSPDFDocument *)document didSaveAnnotations:(NSArray *)annotations {
    NSLog(@"Successfully saved annotations: %@", annotations);

    if (document.data) NSLog(@"This is your time to save the updated data!");
}

- (void)pdfDocument:(PSPDFDocument *)document failedToSaveAnnotations:(NSArray *)annotations error:(NSError *)error {
    NSLog(@"Failed to save annotations: %@", error.localizedDescription);
}

@end
