//
//  PSCSaveAsPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSCSaveAsPDFViewController.h"

@interface PSCSaveAsPDFViewController ()
@property (nonatomic, assign) BOOL hasUserBeenAskedAboutSaveLocation;
@property (nonatomic, strong) PSPDFAlertView *annotationSaveAlertView;
@end

@implementation PSCSaveAsPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    self.rightBarButtonItems = @[self.annotationButtonItem, self.viewModeButtonItem];

    // PSPDFViewController will unregister all notifications on dealloc.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(annotationChangedOrAddedNotification:) name:PSPDFAnnotationChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(annotationChangedOrAddedNotification:) name:PSPDFAnnotationAddedNotification object:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)annotationChangedOrAddedNotification:(NSNotification *)notification {
    PSPDFAnnotation *annotation = notification.object;
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
        }while ([[NSFileManager defaultManager] fileExistsAtPath:newPath]);
        NSURL *newURL = [NSURL fileURLWithPath:newPath];

        NSError *error;
        if (![[NSFileManager defaultManager] copyItemAtURL:self.document.fileURL toURL:newURL error:&error]) {
            PSPDFLogWarning(@"Failed to copy file to %@: %@", newURL.path, [error localizedDescription]);
        }else {
            // Since the annotation has already been edited, we copy the file *before* it will be saved
            // then save the current state and switch out the documents.
            if (![self.document saveChangedAnnotationsWithError:&error]) {
                PSPDFLogWarning(@"Failed to save annotations: %@", [error localizedDescription]);
            }
            NSURL *tmpURL = [newURL URLByAppendingPathExtension:@"temp"];
            if (![[NSFileManager defaultManager] moveItemAtURL:self.document.fileURL toURL:tmpURL error:&error]) {
                PSPDFLogWarning(@"Failed to move file: %@", [error localizedDescription]); return;
            }
            if (![[NSFileManager defaultManager] moveItemAtURL:newURL toURL:self.document.fileURL error:&error]) {
                PSPDFLogWarning(@"Failed to move file: %@", [error localizedDescription]); return;
            }
            if (![[NSFileManager defaultManager] moveItemAtURL:tmpURL toURL:newURL error:&error]) {
                PSPDFLogWarning(@"Failed to move file: %@", [error localizedDescription]); return;
            }
            // Finally update the fileURL, this will clear the current document cache.
            self.document.fileURL = newURL;
        }
    }];
#pragma clang diagnostic pop
    [self.annotationSaveAlertView showWithTintColor:self.alertViewTintColor];
}

@end
