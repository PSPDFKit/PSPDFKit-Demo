//
//  PSCFormExamples.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAppDelegate.h"
#import "PSCAssetLoader.h"
#import "PSCFileHelper.h"
#import "UIBarButtonItem+PSCBlockSupport.h"

static PSPDFViewController *PSPDFFormExampleInvokeWithFilename(NSString *filename) {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:filename]];
    return [[PSPDFViewController alloc] initWithDocument:document];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Interactive digital signing process

@interface PSCFormInteractiveDigitalSigningExample : PSCExample @end
@implementation PSCFormInteractiveDigitalSigningExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Digital signing process (password: test)";
        self.category = PSCExampleCategoryForms;
        self.priority = 20;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    NSURL *resURL = NSBundle.mainBundle.resourceURL;
    NSURL *samplesURL = [resURL URLByAppendingPathComponent:@"Samples"];
    NSURL *p12URL = [samplesURL URLByAppendingPathComponent:@"JohnAppleseed.p12"];

    NSData *p12data = [NSData dataWithContentsOfURL:p12URL];
    PSPDFPKCS12 *p12 = [[PSPDFPKCS12 alloc] initWithData:p12data];
    if (p12) {
        PSPDFPKCS12Signer *p12signer = [[PSPDFPKCS12Signer alloc] initWithDisplayName:@"John Appleseed" PKCS12:p12];

        PSPDFSignatureManager *signatureManager = [PSPDFSignatureManager sharedManager];
        [signatureManager registerSigner:p12signer];

        // Add certs to trust store for the signature validation process
        NSURL *certURL = [samplesURL URLByAppendingPathComponent:@"JohnAppleseed.p7c"];
        NSData *certData = [NSData dataWithContentsOfURL:certURL];

        NSError *error = nil;
        NSArray *certificates = [PSPDFX509 certificatesFromPKCS7Data:certData error:&error];
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            for (PSPDFX509 *x509 in certificates) {
                [signatureManager addTrustedCertificate:x509];
            }
        }
    } else {
        NSLog(@"OpenSSL version of the PSPDFKit is required");
    }

    NSURL *documentURL = [samplesURL URLByAppendingPathComponent:@"Form_example.pdf"];
    NSString *docsFolder = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *newPath = [docsFolder stringByAppendingPathComponent:[documentURL lastPathComponent]];
    NSURL *newURL = [NSURL fileURLWithPath:newPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:newURL.path]) {
        [[NSFileManager defaultManager] removeItemAtURL:newURL error:NULL];
    }

    NSError *error;
    // Make sure the folder exists
    [[NSFileManager defaultManager] createDirectoryAtURL:newURL.URLByDeletingLastPathComponent withIntermediateDirectories:YES attributes:nil error:&error];

    // Copy the file
    if (![[NSFileManager defaultManager] copyItemAtURL:documentURL toURL:newURL error:&error]) {
        NSLog(@"Error while copying %@ to %@: %@", documentURL.path, newURL.path, error.localizedDescription);
        return nil;
    }

    PSPDFDocument *document = [PSPDFDocument documentWithURL:newURL];
    document.annotationSaveMode = PSPDFAnnotationSaveModeEmbedded;

    return [[PSPDFViewController alloc] initWithDocument:document];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Automated digital signing process

@interface PSCFormDigitalSigningExample : PSCExample @end
@implementation PSCFormDigitalSigningExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Automated digital signing process";
        self.category = PSCExampleCategoryForms;
        self.priority = 20;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {

    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSURL *p12URL = [samplesURL URLByAppendingPathComponent:@"JohnAppleseed.p12"];

    NSData *p12data = [NSData dataWithContentsOfURL:p12URL];
    NSAssert(p12data, @"Error reading p12 data from %@", p12URL);
    PSPDFPKCS12 *p12 = [[PSPDFPKCS12 alloc] initWithData:p12data];
    if (!p12) {
        NSLog(@"OpenSSL version of the PSPDFKit is required");
        return nil;
    }
    PSPDFPKCS12Signer *signer = [[PSPDFPKCS12Signer alloc] initWithDisplayName:@"John Appleseed" PKCS12:p12];
    PSPDFSignatureManager *signatureManager = [PSPDFSignatureManager sharedManager];
    [signatureManager registerSigner:signer];

    // Add certs to trust store for the signature validation process
    NSURL *certURL = [samplesURL URLByAppendingPathComponent:@"JohnAppleseed.p7c"];
    NSData *certData = [NSData dataWithContentsOfURL:certURL];

    NSError *error = nil;
    NSArray *certificates = [PSPDFX509 certificatesFromPKCS7Data:certData error:&error];
    NSAssert(error == nil, @"Error loading certificates - %@", error.localizedDescription);
    for (PSPDFX509 *x509 in certificates) {
        [signatureManager addTrustedCertificate:x509];
    }

    PSPDFDocument *unsignedDocument = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Form_example.pdf"]];
    NSArray *annots = [unsignedDocument annotationsForPage:0 type:PSPDFAnnotationTypeWidget];
    PSPDFSignatureFormElement *elem = nil;
    for (PSPDFAnnotation *annot in annots) {
        if ([annot isKindOfClass:PSPDFSignatureFormElement.class]) {
            elem = (PSPDFSignatureFormElement *)annot;
            break;
        }
    }
    NSAssert(elem, @"Cannot find the signature field");

    NSString *fileName = [NSString stringWithFormat:@"%@.pdf", [[NSUUID UUID] UUIDString]];
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
    __block PSPDFDocument *signedDocument = nil;
    // sign the document
    [signer signFormElement:elem usingPassword:@"test" writeTo:path completion:^(BOOL success, PSPDFDocument *document, NSError *err) {
        signedDocument = document;
    }];
    NSAssert(signedDocument, @"Error signing document");
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:signedDocument];

    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Programmatic Form Filling

@interface PSCFormFillingExample : PSCExample @end
@implementation PSCFormFillingExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Programmatic Form Filling";
        self.contentDescription = @"Automatically fills out all forms in code.";
        self.category = PSCExampleCategoryForms;
        self.priority = 30;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:@"Form_example.pdf"]];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;

    // Get all form objects and fill them in.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSArray *annotations = [document annotationsForPage:0 type:PSPDFAnnotationTypeWidget];
        for (PSPDFFormElement *formElement in annotations) {
            [NSThread sleepForTimeInterval:0.8f];

            // Always update the model on the main thread.
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([formElement isKindOfClass:PSPDFTextFieldFormElement.class]) {
                    // Change model on main thread and send a change notification.
                    formElement.contents = [NSString stringWithFormat:@"Test %@", formElement.fieldName];
                    [NSNotificationCenter.defaultCenter postNotificationName:PSPDFAnnotationChangedNotification object:formElement userInfo:@{PSPDFAnnotationChangedNotificationKeyPathKey : @[@"contents"]}];
                } else if ([formElement isKindOfClass:PSPDFButtonFormElement.class]) {
                    [(PSPDFButtonFormElement *)formElement toggleButtonSelectionStateAndSendNotification:YES];
                }
            });
        }
    });

    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

    // Add feature to save a copy of the PDF.
    UIBarButtonItem *saveCopy = [[UIBarButtonItem alloc] initWithTitle:@"Save Copy" style:UIBarButtonItemStylePlain block:^(id sender) {
        // Create a copy of the document
        NSURL *tempURL = PSCTempFileURLWithPathExtension([NSString stringWithFormat:@"copy_%@", document.fileURL.lastPathComponent], @"pdf");
        [NSFileManager.defaultManager copyItemAtURL:document.fileURL toURL:tempURL error:NULL];
        PSPDFDocument *documentCopy = [PSPDFDocument documentWithURL:tempURL];

        // Transfer form values
        NSArray *annotations = [document annotationsForPage:0 type:PSPDFAnnotationTypeWidget];
        NSArray *annotationsCopy = [documentCopy annotationsForPage:0 type:PSPDFAnnotationTypeWidget];
        NSAssert(annotations.count == annotationsCopy.count, @"This example is built to only fill forms - don't add/remove annotations.");

        [annotationsCopy enumerateObjectsUsingBlock:^(PSPDFFormElement *formElement, NSUInteger idx, BOOL *stop) {
            if ([formElement isKindOfClass:PSPDFTextFieldFormElement.class]) {
                formElement.contents = [annotations[idx] contents];
            }
        }];

        [documentCopy saveAnnotationsWithError:NULL];

        [[[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"Document copy saved to %@", documentCopy.fileURL.path] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
    }];
    pdfController.leftBarButtonItems = @[pdfController.closeButtonItem, saveCopy];
    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCFormDigitallySignedModifiedExample

@interface PSCFormDigitallySignedModifiedExample : PSCExample @end
@implementation PSCFormDigitallySignedModifiedExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Example of a PDF Interactive Form with a Digital Signature";
        self.category = PSCExampleCategoryForms;
        self.priority = 10;
        //PSPDFDigitalSignatureManager.sharedManager.delegate = PSCFormExampleSignatureDelegate.sharedDelegate;
    }
    return self;
}

- (void)dealloc {
    //PSPDFDigitalSignatureManager.sharedManager.delegate = nil;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    return PSPDFFormExampleInvokeWithFilename(@"Form_example_signed.pdf");
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -  PSCFormWithFormatting

@interface PSCFormWithFormatting : PSCExample @end
@implementation PSCFormWithFormatting

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"PDF Form with formatted text fields.";
        self.category = PSCExampleCategoryForms;
        self.priority = 50;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader documentWithName:@"Forms_formatted.pdf"];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 

@interface PSCFormFillingAndSavingExample : PSCExample @end
@implementation PSCFormFillingAndSavingExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Programmatically fill form and save";
        self.category = PSCExampleCategoryForms;
        self.priority = 150;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    // Get the example form and copy it to a writable location
    NSURL *fileURL = [NSURL psc_sampleURLWithName:@"Testcase_Form_Auftrag_PDF_Unite.pdf"];
    NSURL *documentURL = PSCCopyFileURLToDocumentFolderAndOverride(fileURL, YES);

    PSPDFDocument *document = [PSPDFDocument documentWithURL:documentURL];
    document.annotationSaveMode = PSPDFAnnotationSaveModeEmbedded;

    [document annotationsForPage:0 type:PSPDFAnnotationTypeWidget];
    for (PSPDFFormElement *formElement in document.formParser.forms) {
        if ([formElement isKindOfClass:PSPDFButtonFormElement.class]) {
            if ([formElement.fieldName isEqualToString:@"bereits Kunde"]) {
                [(PSPDFButtonFormElement *)formElement.kids[1] select];
            }
        }
    }

    [document saveAnnotationsWithCompletionBlock:^(NSArray *savedAnnotations, NSError *error) {
        NSLog(@"Saved with Error: %@", error.localizedFailureReason);
    }];

    NSLog(@"File saved to %@", documentURL.path);

    return nil;
}

@end
