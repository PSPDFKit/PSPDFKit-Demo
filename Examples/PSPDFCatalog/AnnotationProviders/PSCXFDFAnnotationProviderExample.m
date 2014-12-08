//
//  PSCXFDFAnnotationProviderExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2014-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAssetLoader.h"
#import "UIBarButtonItem+PSCBlockSupport.h"

@interface PSCXFDFAnnotationProviderExample : PSCExample @end
@implementation PSCXFDFAnnotationProviderExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"XFDF Annotation Provider";
        self.contentDescription = @"XFDF is an XML-based Adobe standard and a perfect format for syncing annotations/form values with a server.";
        self.category = PSCExampleCategoryAnnotationProviders;
        self.priority = 80;
    }
    return self;
}

// This example shows how you can create an XFDF provider instead of the default file-based one.
// XFDF is an industry standard and the file will be interopable with Adobe Acrobat or any other standard-compliant PDF framework.
- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *documentURL = [samplesURL URLByAppendingPathComponent:PSPDFHackerMagazineAsset];
    //NSURL *documentURL = [samplesURL URLByAppendingPathComponent:@"Testcase_Form_YesNo.pdf"];

    // Load from an example XFDF file.
    NSString *docsFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSURL *fileXML = [NSURL fileURLWithPath:[docsFolder stringByAppendingPathComponent:@"XFDFTest.xfdf"]];
    NSLog(@"Using XFDF file at %@", fileXML.path);

    // Create an example XFDF from the current document if one doesn't already exist.
    //[NSFileManager.defaultManager removeItemAtURL:fileXML error:NULL]; // DEBUG HELPER: delete existing file.
    if (![NSFileManager.defaultManager fileExistsAtPath:fileXML.path]) {
        // Collect all existing annotations from the document
        PSPDFDocument *tempDocument = [PSPDFDocument documentWithURL:documentURL];
        NSMutableArray *annotations = [NSMutableArray array];
        for (NSArray *pageAnnots in [tempDocument allAnnotationsOfType:PSPDFAnnotationTypeAll].allValues) {
            [annotations addObjectsFromArray:pageAnnots];
        }
        // Write the file
        NSError *error = nil;
        NSOutputStream *outputStream = [NSOutputStream outputStreamWithURL:fileXML append:NO];
        if (![[PSPDFXFDFWriter new] writeAnnotations:annotations toOutputStream:outputStream documentProvider:tempDocument.documentProviders[0] error:&error]) {
            NSLog(@"Failed to write XFDF file: %@", error.localizedDescription);
        }
        [outputStream close];
    }

    // Create document and set up the XFDF provider.
    PSPDFDocument *document = [PSPDFDocument documentWithURL:documentURL];
    document.annotationSaveMode = PSPDFAnnotationSaveModeExternalFile;
    [document setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
        PSPDFXFDFAnnotationProvider *XFDFProvider = [[PSPDFXFDFAnnotationProvider alloc] initWithDocumentProvider:documentProvider fileURL:fileXML];
        documentProvider.annotationManager.annotationProviders = @[XFDFProvider];
    }];

    PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:document];
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"") style:UIBarButtonItemStyleBordered block:^(id sender) {
        [document saveAnnotationsWithCompletionBlock:^(NSArray *savedAnnotations, NSError *error) {
            if (!error) {
                unsigned long long XFDFFileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:fileXML.path error:NULL] fileSize];
                NSLog(@"Saving done. (XFDF file size: %lld)", XFDFFileSize);
            } else {
                NSLog(@"Saving failed: %@", error.localizedDescription);
            }
        }];
    }];
    controller.leftBarButtonItems = @[controller.closeButtonItem, saveButton];
    return controller;
}

@end

@interface PSCEncryptedXFDFAnnotationProviderExample : PSCExample @end
@implementation PSCEncryptedXFDFAnnotationProviderExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"XFDF Annotation Provider, Encrypted";
        self.contentDescription = @"Variant that encrypts/decrypts the XFDF file on-the-fly.";
        self.category = PSCExampleCategoryAnnotationProviders;
        self.priority = 81;
    }
    return self;
}

// This example shows how you can create an XFDF provider instead of the default file-based one.
// XFDF is an industry standard and the file will be interopable with Adobe Acrobat or any other standard-compliant PDF framework.
- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *documentURL = [samplesURL URLByAppendingPathComponent:PSPDFHackerMagazineAsset];

    // Load from an example XFDF file.
    NSString *passphrase = @"jJ9A3BiMXoq+rEoYMdqBoBNzgxagTf";
    NSString *docsFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSURL *fileXML = [NSURL fileURLWithPath:[docsFolder stringByAppendingPathComponent:@"XFDFTest-encrypted.xfdf"]];
    NSLog(@"Using XFDF file at %@", fileXML.path);

    // Create an example XFDF from the current document if one doesn't already exist.
    //[NSFileManager.defaultManager removeItemAtURL:fileXML error:NULL]; // DEBUG HELPER: delete existing file.
    if (![NSFileManager.defaultManager fileExistsAtPath:fileXML.path]) {
        // Collect all existing annotations from the document
        PSPDFDocument *tempDocument = [PSPDFDocument documentWithURL:documentURL];
        NSMutableArray *annotations = [NSMutableArray array];
        for (NSArray *pageAnnots in [tempDocument allAnnotationsOfType:PSPDFAnnotationTypeAll].allValues) {
            [annotations addObjectsFromArray:pageAnnots];
        }
        // Write the file
        NSError *error = nil;
        NSOutputStream *outputStream = [[PSPDFAESCryptoOutputStream alloc] initWithOutputStream:[NSOutputStream outputStreamWithURL:fileXML append:NO] passphrase:passphrase];
        if (![[PSPDFXFDFWriter new] writeAnnotations:annotations toOutputStream:outputStream documentProvider:tempDocument.documentProviders[0] error:&error]) {
            NSLog(@"Failed to write XFDF file: %@", error.localizedDescription);
        }
        [outputStream close];
    }

    // Create document and set up the XFDF provider.
    PSPDFDocument *document = [PSPDFDocument documentWithURL:documentURL];
    document.annotationSaveMode = PSPDFAnnotationSaveModeExternalFile;
    [document setDidCreateDocumentProviderBlock:^(PSPDFDocumentProvider *documentProvider) {
        PSPDFXFDFAnnotationProvider *XFDFProvider = [[PSPDFXFDFAnnotationProvider alloc] initWithDocumentProvider:documentProvider];
        XFDFProvider.createInputStreamBlock = ^(PSPDFXFDFAnnotationProvider *annotationProvider) {
            return [[PSPDFAESCryptoInputStream alloc] initWithInputStream:[[NSInputStream alloc] initWithURL:fileXML] passphrase:passphrase];
        };
        XFDFProvider.createOutputStreamBlock = ^(PSPDFXFDFAnnotationProvider *annotationProvider) {
            return [[PSPDFAESCryptoOutputStream alloc] initWithOutputStream:[NSOutputStream outputStreamWithURL:fileXML append:NO] passphrase:passphrase];
        };
        documentProvider.annotationManager.annotationProviders = @[XFDFProvider];
    }];

    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end
