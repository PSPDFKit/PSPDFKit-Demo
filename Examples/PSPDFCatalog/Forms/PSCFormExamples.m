//
//  PSCFormExamples.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"
#import "PSCAppDelegate.h"
#import "PSCAssetLoader.h"
#import "PSPDFPKCS12Signer.h"
#import "PSPDFSignatureManager.h"


static PSPDFViewController *PSPDFFormExampleInvokeWithFilename(NSString *filename) {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:filename]];
    return [[PSPDFViewController alloc] initWithDocument:document];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCFormExample

@interface PSCFormExample : PSCExample
@end

@implementation PSCFormExample

- (id)init {
    if (self = [super init]) {
        self.title = @"PDF AcroForm";
        self.contentDescription = @"PSPDFKit Complete/Enterprise supports PDF AcroForms.";
        self.category = PSCExampleCategoryForms;
        self.priority = 20;

		NSURL *resURL = NSBundle.mainBundle.resourceURL;
		NSURL *samplesURL = [resURL URLByAppendingPathComponent:@"Samples"];
		NSURL *p12URL = [samplesURL URLByAppendingPathComponent:@"JohnAppleseed.p12"];
		
		NSData *p12data = [NSData dataWithContentsOfURL:p12URL];
		PSPDFPKCS12 *p12 = [[PSPDFPKCS12 alloc] initWithData:p12data];
		PSPDFPKCS12Signer *p12signer = [[PSPDFPKCS12Signer alloc] initWithDisplayName:@"John Appleseed"
																			   PKCS12:p12];
		

		
		
		PSPDFSignatureManager *smgr = [PSPDFSignatureManager sharedManager];
		
		[smgr registerSigner:p12signer];
		
		// Add certs to trust store
		NSURL *certURL = [samplesURL URLByAppendingPathComponent:@"JohnAppleseed.p7c"];
		NSData *certData = [NSData dataWithContentsOfURL:certURL];
		
		NSError *err = nil;
		NSArray *certs = [PSPDFX509 certificatesFromPKCS7Data:certData error:&err];
		if (err != nil) {
			NSLog(@"ERROR: %@", err.localizedDescription);
		} else {
			for (PSPDFX509 *x509 in certs) {
				[smgr addTrustedCertificate:x509];
			}
		}
		
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    return PSPDFFormExampleInvokeWithFilename(@"Form_example.pdf");
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Programmatic Form Filling

@interface PSCFormFillingExample : PSCExample @end
@implementation PSCFormFillingExample

- (id)init {
    if (self = [super init]) {
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
            if ([formElement isKindOfClass:PSPDFTextFieldFormElement.class]) {
                [NSThread sleepForTimeInterval:1.f];

                // Change model on main thread and send a change notification.
                dispatch_async(dispatch_get_main_queue(), ^{
                    formElement.contents = [NSString stringWithFormat:@"Test %@", formElement.fieldName];
                    [NSNotificationCenter.defaultCenter postNotificationName:PSPDFAnnotationChangedNotification object:formElement userInfo:@{PSPDFAnnotationChangedNotificationKeyPathKey : @[@"contents"]}];
                });
            }
        }
    });

    return [[PSPDFViewController alloc] initWithDocument:document];
}
@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCFormDigitallySignedModifiedExample

@interface PSCFormDigitallySignedModifiedExample : PSCExample
@end

@implementation PSCFormDigitallySignedModifiedExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Example of a PDF Interactive Form with a Digital Signature";
        self.contentDescription = @"PSPDFKit Complete/Enterprise supports Digital Signature validation.";
        self.category = PSCExampleCategoryForms;
        self.priority = 10;
//        PSPDFDigitalSignatureManager.sharedManager.delegate = PSCFormExampleSignatureDelegate.sharedDelegate;
    }
    return self;
}

- (void)dealloc {
//    PSPDFDigitalSignatureManager.sharedManager.delegate = nil;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    return PSPDFFormExampleInvokeWithFilename(@"Form_example_signed.pdf");
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -  PSCFormWithFormatting

@interface PSCFormWithFormatting : PSCExample @end
@implementation PSCFormWithFormatting

- (id)init {
    if (self = [super init]) {
        self.title = @"PDF Form with formatted text fields.";
        self.category = PSCExampleCategoryForms;
        self.priority = 50;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:@"Testcase_Formatted_Forms.pdf"];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end
