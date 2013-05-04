//
//  PSCMultipleUsersPDFViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSCMultipleUsersPDFViewController.h"

@interface PSCMultipleUsersPDFViewController ()
@property (nonatomic, copy) NSString *currentUsername;
@end

@implementation PSCMultipleUsersPDFViewController

- (void)commonInitWithDocument:(PSPDFDocument *)document {
    [super commonInitWithDocument:document];

    // Set a demo user.
    self.currentUsername = @"Testuser";

    // Set custom toolbar button.
    [self updateCustomToolbar];
    self.rightBarButtonItems = @[self.annotationButtonItem, self.viewModeButtonItem];

    // This example will only work for external file save mode.
    document.annotationSaveMode = PSPDFAnnotationSaveModeExternalFile;

    // Updates the path at the right time.
    [document setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
    documentProvider.annotationParser.fileAnnotationProvider.annotationsPath = [documentProvider.document.dataDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"annotations_%@.pspdfkit", self.currentUsername]];
    }];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)updateCustomToolbar {
    UIBarButtonItem *switchUserButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"User: %@", self.currentUsername] style:UIBarButtonItemStyleBordered target:self action:@selector(switchUser)];
    self.leftBarButtonItems = @[self.closeButtonItem, switchUserButtonItem];
}

// This could be a lot sexier - e.g. showing all available users in a nice table with edit/delete all etc.
- (void)switchUser {
    // Save existing documents.
    [self.document saveChangedAnnotationsWithError:NULL];
    
    PSPDFAlertView *userPrompt = [[PSPDFAlertView alloc] initWithTitle:@"Switch user" message:@"Enter username."];
    userPrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[userPrompt textFieldAtIndex:0] setText:self.currentUsername];

    [userPrompt setCancelButtonWithTitle:@"Cancel" block:nil];
    [userPrompt addButtonWithTitle:@"Switch" block:^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        NSString *username = [userPrompt textFieldAtIndex:0].text ?: @"";
#pragma clang diagnostic pop

        // TODO: In a real application you want to make the username unique and also check for characters that are trouble on file systems.

        // Set new username
        self.currentUsername = username;

        // To switch annotations, we could also clear the cache, but PSPDFKit is smart enough to detect the changes itself.
        // [[PSPDFCache sharedCache] removeCacheForDocument:self.document deleteDocument:NO error:NULL];
        
        // Then clear the document cache (forces document provider regeneration)
        [self.document clearCache];
        // Update toolbar to show new name.
        [self updateCustomToolbar];
        // And finally - redraw the PDF.
        [self reloadData];
    }];
    [userPrompt show];
}

@end
