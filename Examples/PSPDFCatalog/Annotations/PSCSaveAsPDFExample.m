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
@property (nonatomic, strong) PSPDFActionSheet *annotationSaveActionSheet;
@property (nonatomic, weak) id saveActionSender;
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
    NSURL *writableDocumentURL = PSCCopyFileURLToDocumentFolderAndOverride(documentURL, NO);
    PSPDFDocument *document = [PSPDFDocument documentWithURL:writableDocumentURL];
    return [[PSCSaveAsPDFViewController alloc] initWithDocument:document];
}

@end

@implementation PSCSaveAsPDFViewController

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];
    self.rightBarButtonItems = @[self.annotationButtonItem, self.viewModeButtonItem];

    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithTitle:PSPDFLocalize(@"Close") style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonPressed:)];
    self.leftBarButtonItems = @[closeButton];

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

- (void)closeButtonPressed:(id)sender {
    self.saveActionSender = sender;
    self.annotationStateManager.state = nil; // Commit any annotations.
    self.saveActionSender = nil;

    UINavigationController *navigationController = self.navigationController;
    if (!self.annotationSaveActionSheet.isVisible) {
        [navigationController popViewControllerAnimated:YES];
    }else {
        [self.annotationSaveActionSheet addWillDismissBlock:^(NSInteger buttonIndex) {
            [navigationController popViewControllerAnimated:YES];
        }];
    }
}

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
            // The notification might not be on main thread.
            if (NSThread.isMainThread) {
                [self askUserAboutSaveLocationFromSender:self.saveActionSender];
            }else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self askUserAboutSaveLocationFromSender:self.saveActionSender];
                });
            }
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Document Copying Logic

// This code assumes that the PDF location itself is writeable, and will fail for documents in the bundle folder.
- (void)askUserAboutSaveLocationFromSender:(id)sender {
    PSPDFActionSheet *annotationSaveActionSheet = [[PSPDFActionSheet alloc] initWithTitle:NSLocalizedString(@"Would you like to save annotations into the current file, or create a copy to save the annotation changes?", @"")];
    [annotationSaveActionSheet setDestructiveButtonWithTitle:@"Save to this file" block:^(NSInteger buttonIndex) {
        self.hasUserBeenAskedAboutSaveLocation = YES;
        // We're all set, don't need to do more.
    }];
    [annotationSaveActionSheet addButtonWithTitle:@"Save as Copy" block:^(NSInteger buttonIndex) {
        self.hasUserBeenAskedAboutSaveLocation = YES;
        [self replaceDocumentWithCopy];
    }];
    [annotationSaveActionSheet addWillDismissBlock:^(NSInteger buttonIndex) {
        self.annotationSaveActionSheet = nil;
    }];
    [annotationSaveActionSheet addCancelBlock:^(NSInteger buttonIndex) {
        self.hasUserBeenAskedAboutSaveLocation = YES;
    }];
    annotationSaveActionSheet.allowsTapToDismiss = NO;
    [annotationSaveActionSheet showWithSender:sender fallbackView:self.view animated:YES];
    self.annotationSaveActionSheet = annotationSaveActionSheet;

    if (self.annotationSaveActionSheet.isVisible) return;
}

- (void)replaceDocumentWithCopy {
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
}

@end
