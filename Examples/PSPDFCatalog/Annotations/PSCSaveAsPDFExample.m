//
//  PSCSaveAsPDFExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"
#import "PSCFileHelper.h"

/// This class will ask the user as soon as the first annotation has been added/modified
/// where the annotation should be saved, and optionally copies the file to a new location.
@interface PSCSaveAsPDFViewController : PSPDFViewController
@property (nonatomic, assign) BOOL hasUserBeenAskedAboutSaveLocation;
@property (nonatomic, strong) PSPDFAlertView *annotationSaveAlertView;
@end

@interface PSCAnnotationsSaveAsForAnnotationEditingExample : PSCExample @end
@implementation PSCAnnotationsSaveAsForAnnotationEditingExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Save as... for annotation editing";
        self.contentDescription = @"Adds an alert after detecting annotation writes to define a new save location.";
        self.category = PSCExampleCategoryAnnotations;
        self.priority = 70;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *documentURL = [samplesURL URLByAppendingPathComponent:kHackerMagazineExample];
    NSURL *writableDocumentURL = PSCCopyFileURLToDocumentFolderAndOverride(documentURL, YES);
    PSPDFDocument *linkDocument = [PSPDFDocument documentWithURL:writableDocumentURL];
    return [[PSCSaveAsPDFViewController alloc] initWithDocument:linkDocument];
}

@end

@implementation PSCSaveAsPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    self.rightBarButtonItems = @[self.annotationButtonItem, self.viewModeButtonItem];

    // PSPDFViewController will unregister all notifications on dealloc.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(annotationChangedNotification:) name:PSPDFAnnotationChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(annotationAddedOrRemovedNotification:) name:PSPDFAnnotationsAddedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(annotationAddedOrRemovedNotification:) name:PSPDFAnnotationsRemovedNotification object:nil];
}

- (void)dealloc {
    // Clear document cache, so we don't get annotation-artefacts when loading the doc again.
    [PSPDFCache.sharedCache removeCacheForDocument:self.document deleteDocument:NO error:NULL];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)annotationChangedNotification:(NSNotification *)notification {
    [self processChangeForAnnotation:notification.object];
}

- (void)annotationAddedOrRemovedNotification:(NSNotification *)notification {
    for (PSPDFAnnotation *annotation in notification.object) {
        [self processChangeForAnnotation:annotation];
    }
}

- (void)processChangeForAnnotation:(PSPDFAnnotation *)annotation {
    if (annotation.document == self.document) {
        if (!self.hasUserBeenAskedAboutSaveLocation) {
            // notification might not be on main thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self askUserAboutSaveLocation];
            });
        }
    }
}

// This code assumes that the PDF location itself is writeable, and will fail for documents in the bundle folder.
- (void)askUserAboutSaveLocation {
    if (self.annotationSaveAlertView) return; // don't show multiple times

    self.annotationSaveAlertView = [[PSPDFAlertView alloc] initWithTitle:@"Annotation Save Location" message:@"Would you like to save annotations into the current file, or create a copy to save the annotation changes?"];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
    [self.annotationSaveAlertView addButtonWithTitle:@"Save to this file" block:^{
        self.hasUserBeenAskedAboutSaveLocation = YES;
        // We're all set, don't need to do more.
    }];
    [self.annotationSaveAlertView addButtonWithTitle:@"Create Copy" block:^{
        self.hasUserBeenAskedAboutSaveLocation = YES;

        // Build new URL, tests for a filename that doesn't yet exist.
        NSUInteger appendFileCount = 0;
        NSString *newPath;
        do {
            newPath = self.document.fileURL.path;
            NSString *appendSuffix = [NSString stringWithFormat:@"_annotated%@.pdf", appendFileCount == 0 ? @"" : @(appendFileCount)];
            if ([newPath.lowercaseString hasSuffix:@".pdf"]) {
                newPath = [newPath stringByReplacingOccurrencesOfString:@".pdf" withString:appendSuffix options:NSCaseInsensitiveSearch range:NSMakeRange(newPath.length-4, 4)];
            }else {
                newPath = [newPath stringByAppendingString:appendSuffix];
            }
            appendFileCount++;
        }while ([NSFileManager.defaultManager fileExistsAtPath:newPath]);
        NSURL *newURL = [NSURL fileURLWithPath:newPath];

        NSError *error;
        if (![NSFileManager.defaultManager copyItemAtURL:self.document.fileURL toURL:newURL error:&error]) {
            NSLog(@"Failed to copy file to %@: %@", newURL.path, error.localizedDescription);
        }else {
            // Since the annotation has already been edited, we copy the file *before* it will be saved
            // then save the current state and switch out the documents.
            if (![self.document saveAnnotationsWithError:&error]) {
                NSLog(@"Failed to save annotations: %@", error.localizedDescription);
            }
            NSURL *tmpURL = [newURL URLByAppendingPathExtension:@"temp"];
            if (![NSFileManager.defaultManager moveItemAtURL:self.document.fileURL toURL:tmpURL error:&error]) {
                NSLog(@"Failed to move file: %@", error.localizedDescription); return;
            }
            if (![NSFileManager.defaultManager moveItemAtURL:newURL toURL:self.document.fileURL error:&error]) {
                NSLog(@"Failed to move file: %@", error.localizedDescription); return;
            }
            if (![NSFileManager.defaultManager moveItemAtURL:tmpURL toURL:newURL error:&error]) {
                NSLog(@"Failed to move file: %@", error.localizedDescription); return;
            }
            // Finally update the fileURL, this will clear the current document cache.
            PSPDFDocument *newDocument = [PSPDFDocument documentWithURL:newURL];
            newDocument.title = self.document.title; // preserve title.
            self.document = newDocument;
        }
    }];
#pragma clang diagnostic pop
    [self.annotationSaveAlertView show];
}

@end
