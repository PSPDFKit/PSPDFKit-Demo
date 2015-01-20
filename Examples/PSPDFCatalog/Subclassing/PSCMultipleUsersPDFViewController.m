//
//  PSCMultipleUsersPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCMultipleUsersPDFViewController.h"
#import "PSTAlertController.h"

@interface PSCMultipleUsersPDFViewController ()
@property (nonatomic, copy) NSString *currentUsername;
@end

@implementation PSCMultipleUsersPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document configuration:(PSPDFConfiguration *)configuration {
    [super commonInitWithDocument:document configuration:configuration];

    // Set a demo user.
    self.currentUsername = @"Testuser";

    // Updates the path at the right time.
    __weak typeof (self) weakSelf = self;
    [document setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
        documentProvider.annotationManager.fileAnnotationProvider.annotationsPath = [documentProvider.document.dataDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"annotations_%@.pspdfkit", weakSelf.currentUsername]];
    }];

    // This example will only work for external file save mode.
    document.annotationSaveMode = PSPDFAnnotationSaveModeExternalFile;

    // Set custom toolbar button.
    [self updateCustomToolbar];
    self.documentInfoCoordinator.availableControllerOptions = [NSOrderedSet orderedSetWithObject:@(PSPDFOutlineBarButtonItemOptionAnnotations)];
    self.rightBarButtonItems = @[self.annotationButtonItem, self.outlineButtonItem, self.viewModeButtonItem];
}

- (void)setCurrentUsername:(NSString *)currentUsername {
    if (currentUsername != _currentUsername) {
        _currentUsername = [currentUsername copy];
        // Forward to the document
        self.document.defaultAnnotationUsername = currentUsername;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)updateCustomToolbar {
    UIBarButtonItem *switchUserButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"User: %@", self.currentUsername] style:UIBarButtonItemStyleBordered target:self action:@selector(switchUser)];
    self.leftBarButtonItems = @[self.closeButtonItem, switchUserButtonItem];
}

// This could be a lot sexier - e.g. showing all available users in a nice table with edit/delete all etc.
- (void)switchUser {
    // Dismiss any popovers. iOS 8 doesn't like presenting alerts next to them.
    [self dismissPopoverAnimated:YES class:nil completion:nil];

    // Save existing documents.
    [self.document saveAnnotationsWithError:NULL];

    PSTAlertController *alertController = [PSTAlertController alertWithTitle:@"Switch user" message:@"Enter username."];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = self.currentUsername;
    }];
    [alertController addCancelActionWithHandler:nil];
    [alertController addAction:[PSTAlertAction actionWithTitle:@"Switch" handler:^(PSTAlertAction *action) {
        // TODO: In a real application you want to make the username unique and also check for characters that are trouble on file systems.
        NSString *username = action.alertController.textField.text ?: @"";

        // Set new username
        self.currentUsername = username;

        // To switch annotations, we could also clear the cache, but PSPDFKit is smart enough to detect the changes itself.
        // [PSPDFCache.sharedCache removeCacheForDocument:self.document deleteDocument:NO error:NULL];

        // Then clear the document cache (forces document provider regeneration)
        [self.document clearCache];
        // Update toolbar to show new name.
        [self updateCustomToolbar];
        // And finally - redraw the PDF.
        [self reloadData];
    }]];
    [alertController showWithSender:nil controller:self animated:YES completion:nil];
}

@end
