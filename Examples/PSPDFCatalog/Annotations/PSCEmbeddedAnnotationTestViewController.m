//
//  PSCEmbeddedAnnotationTestViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSCEmbeddedAnnotationTestViewController.h"
#import "PSCAnnotationTableBarButtonItem.h"

@implementation PSCEmbeddedAnnotationTestViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)initWithDocument:(PSPDFDocument *)document {
    if ((self = [super initWithDocument:document])) {
        self.renderingMode = PSPDFPageRenderingModeFullPageBlocking;
        
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(saveAnnotations)];
        PSCAnnotationTableBarButtonItem *annotationListButtonItem = [[PSCAnnotationTableBarButtonItem alloc] initWithPDFViewController:self];

        self.leftBarButtonItems = @[self.closeButtonItem, saveButton, annotationListButtonItem];

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

- (void)saveAnnotations {
    NSLog(@"annotations old: %@", [self.document.annotationParser annotationsForPage:0 type:PSPDFAnnotationTypeAll]);

    NSError *error = nil;
    NSDictionary *dirtyAnnotations = [self.document.annotationParser dirtyAnnotations];
    NSLog(@"dirty: %@", dirtyAnnotations);
    if (![self.document saveChangedAnnotationsWithError:&error]) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to save annotations.", @"") message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil] show];
    }else {
        [self reloadData];
        NSLog(@"---------------------------------------------------");
        NSLog(@"annotations new: %@", [self.document.annotationParser annotationsForPage:0 type:PSPDFAnnotationTypeAll]);
        //[[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Success", @"") message:[NSString stringWithFormat:NSLocalizedString(@"Saved %d annotation(s)", @""), dirtyAnnotationCount] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", @"") otherButtonTitles:nil] show];
    }
}

@end
