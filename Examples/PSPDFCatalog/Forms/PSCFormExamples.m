//
//  PSCFormExamples.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCFormExamples.h"
#import "PSCAppDelegate.h"
#import "PSCAssetLoader.h"

#import "PSPDFDigitalCertificate.h"
#import "PSPDFDigitalSigningIdentity.h"

static PSPDFViewController *PSPDFFormExampleInvokeWithFilename(NSString *filename) {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:filename]];
    return [[PSPDFViewController alloc] initWithDocument:document];
}

@interface PSCFormExampleSignatureDelegate : NSObject <PSPDFDigitalSignatureManagerDelegate, PSPDFDigitalSignatureRevisionDelegate, PSPDFDigitalSignatureSigningDelegate>
+ (PSCFormExampleSignatureDelegate *)sharedDelegate;
@property (atomic, strong) NSArray *certificates;
@property (atomic, strong) NSArray *identities;
@end

// Use a singleton to control reactions to signature related events.
@implementation PSCFormExampleSignatureDelegate

+ (PSCFormExampleSignatureDelegate *)sharedDelegate {
    static PSCFormExampleSignatureDelegate *delegate = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{delegate = [PSCFormExampleSignatureDelegate new];});
    return delegate;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDigitalSignatureRevisionDelegate and PSPDFDigitalSignatureSigningDelegate

- (void)pdfRevisionRequested:(PSPDFDocument *)document verificationHandler:(id<PSPDFDigitalSignatureVerificationHandler>)handler {
    NSString *date = [NSDateFormatter localizedStringFromDate:handler.signature.timeSigned dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    NSString *title = [NSString stringWithFormat:@"%@ (%@ - %@)", handler.documentProvider.document.title, date, handler.signature.name];
    [self showDocument:document withTitle:title];
}

- (void)pdfSigned:(PSPDFDocument *)document signingHandler:(id<PSPDFDigitalSignatureSigningHandler>)handler {
    [self showDocument:document withTitle:@"Test"];
    
}

- (void)showDocument:(PSPDFDocument *)document withTitle:(NSString *)title {
    PSPDFViewController *controller = [self viewControllerForDocument:document];
    controller.rightBarButtonItems = @[controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
    
    if (title) document.title = title;
    
    PSCAppDelegate *appDelegate = UIApplication.sharedApplication.delegate;
    [appDelegate.catalog pushViewController:controller animated:YES];
}

- (PSPDFViewController *)viewControllerForDocument:(PSPDFDocument *)document {
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.rightBarButtonItems = @[pdfController.searchButtonItem, pdfController.outlineButtonItem, pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
    pdfController.additionalBarButtonItems = @[pdfController.openInButtonItem, pdfController.bookmarkButtonItem, pdfController.brightnessButtonItem, pdfController.printButtonItem, pdfController.emailButtonItem];
    return pdfController;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDigitalSignatureManagerDelegate

- (NSArray *)trustedCertificates {
    if (!self.certificates) {
        NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
        NSData *cert = [NSData dataWithContentsOfFile:[[samplesURL URLByAppendingPathComponent:@"JohnAppleseed.p7c"] path]];
        self.certificates = @[[PSPDFDigitalCertificate certificateFromData:cert]];
    }
    return self.certificates;
}
- (NSArray *)signingIdentities {
    if (!self.identities) {
        NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
        self.identities = @[[PSPDFDigitalSigningIdentity signingIdentityWithFilePath:[[samplesURL URLByAppendingPathComponent:@"JohnAppleseed.p12"] path] name:@"John Appleseed"]];
    }
    return self.identities;
}
- (BOOL)useAdobeCA {return YES;}
- (NSArray *)revisionDelegates {return @[self];}
- (NSArray *)signingDelegates {return @[self];}
- (NSArray *)signingHandlers {return @[];}
- (NSArray *)verificationHandlers {return @[];}
@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCFormExample

@implementation PSCFormExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Example of a PDF Interactive Form";
        self.category = PSCExampleCategoryForms;
        self.priority = 20;
        PSPDFDigitalSignatureManager.sharedManager.delegate = PSCFormExampleSignatureDelegate.sharedDelegate;
    }
    return self;
}

- (void)dealloc {
    PSPDFDigitalSignatureManager.sharedManager.delegate = nil;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    return PSPDFFormExampleInvokeWithFilename(@"Form_example.pdf");
}
@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCFormDigitallySignedModifiedExample

@implementation PSCFormDigitallySignedModifiedExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Example of a PDF Interactive Form with a Digital Signature";
        self.category = PSCExampleCategoryForms;
        self.priority = 10;
        PSPDFDigitalSignatureManager.sharedManager.delegate = PSCFormExampleSignatureDelegate.sharedDelegate;
    }
    return self;
}

- (void)dealloc {
    PSPDFDigitalSignatureManager.sharedManager.delegate = nil;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    return PSPDFFormExampleInvokeWithFilename(@"Form_example_signed.pdf");
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -  PSCFormWithFormatting

@implementation PSCFormWithFormatting

- (id)init {
    if (self = [super init]) {
        self.title = @"PDF Form with formatted text fields.";
        self.category = PSCExampleCategoryViewCustomization;
        self.priority = 50;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFDocument *document = [PSCAssetLoader sampleDocumentWithName:@"Testcase_Formatted_Forms.pdf"];
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    return pdfController;
}

@end
