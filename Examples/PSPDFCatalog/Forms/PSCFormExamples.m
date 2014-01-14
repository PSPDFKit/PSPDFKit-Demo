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

static void PSPDFFormExampleAddTrustedCertificates() {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    NSData *cert = [NSData dataWithContentsOfFile:[[samplesURL URLByAppendingPathComponent:@"JohnAppleseed.p7c"] path]];
    [PSPDFDigitalSignatureManager.sharedManager addCertificate:cert error:nil];
}

static PSPDFViewController *PSPDFFormExampleInvokeWithFilename(NSString *filename) {
    NSURL *samplesURL = [NSBundle.mainBundle.resourceURL URLByAppendingPathComponent:@"Samples"];
    PSPDFDocument *document = [PSPDFDocument documentWithURL:[samplesURL URLByAppendingPathComponent:filename]];
    return [[PSPDFViewController alloc] initWithDocument:document];
}

static PSPDFViewController *PSPDFFormExampleViewControllerForDocument(PSPDFDocument *document) {
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.rightBarButtonItems = @[pdfController.searchButtonItem, pdfController.outlineButtonItem, pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
    pdfController.additionalBarButtonItems = @[pdfController.openInButtonItem, pdfController.bookmarkButtonItem, pdfController.brightnessButtonItem, pdfController.printButtonItem, pdfController.emailButtonItem];
    return pdfController;
}

@interface PSCFormExampleSignatureDelegate : NSObject <PSPDFDigitalSignatureRevisionDelegate>
+ (PSCFormExampleSignatureDelegate *)sharedDelegate;
@end

// Use a singleton to control reactions to signature related events.
@implementation PSCFormExampleSignatureDelegate
+ (PSCFormExampleSignatureDelegate *)sharedDelegate {
    static PSCFormExampleSignatureDelegate *delegate = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{delegate = [PSCFormExampleSignatureDelegate new];});
    return delegate;
}
- (void)pdfRevisionRequested:(PSPDFDocument *)document verificationHandler:(id<PSPDFDigitalSignatureVerificationHandler>)handler {
    PSPDFViewController *controller = PSPDFFormExampleViewControllerForDocument(document);
    controller.rightBarButtonItems = @[controller.searchButtonItem, controller.outlineButtonItem, controller.viewModeButtonItem];
    
    NSString *date = [NSDateFormatter localizedStringFromDate:handler.signature.timeSigned dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle];
    document.title = [NSString stringWithFormat:@"%@ (%@ - %@)", handler.documentProvider.document.title, date, handler.signature.name];
    document.annotationSaveMode = PSPDFAnnotationSaveModeDisabled;
    
    PSCAppDelegate *appDelegate = UIApplication.sharedApplication.delegate;
    [appDelegate.catalog pushViewController:controller animated:YES];
}
@end

static void PSPDFFormExampleRegisterForRevisionCallbacks() {
    [PSPDFDigitalSignatureManager.sharedManager registerForReceivingRequestsToViewRevisions:PSCFormExampleSignatureDelegate.sharedDelegate];
}

static void PSPDFFormExampleDeregisterForRevisionCallbacks() {
    [PSPDFDigitalSignatureManager.sharedManager deregisterFromReceivingRequestsToViewRevisions:PSCFormExampleSignatureDelegate.sharedDelegate];
}

@implementation PSCFormExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Example of a PDF Interactive Form";
        self.category = PSCExampleCategoryForms;
        self.priority = 20;
        PSPDFFormExampleAddTrustedCertificates();
        PSPDFFormExampleRegisterForRevisionCallbacks();
    }
    return self;
}

- (void)dealloc {
    PSPDFFormExampleDeregisterForRevisionCallbacks();
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    return PSPDFFormExampleInvokeWithFilename(@"W8_Formular.pdf");
}
@end


@implementation PSCFormDigitallySignedModifiedExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Example of a PDF Interactive Form with a Digital Signature";
        self.category = PSCExampleCategoryForms;
        self.priority = 10;
        PSPDFFormExampleAddTrustedCertificates();
        PSPDFFormExampleRegisterForRevisionCallbacks();
    }
    return self;
}

- (void)dealloc {
    PSPDFFormExampleDeregisterForRevisionCallbacks();
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    return PSPDFFormExampleInvokeWithFilename(@"Form_example_signed.pdf");
}

@end
