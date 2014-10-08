//
//  PSCTextExtractionExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCFileHelper.h"
#import "PSCExample.h"

@interface PSCFullTextSearchExample : PSCExample @end
@interface PSCConvertMarkupStringToPDFExample : PSCExample @end
@interface PSCConvertWebsiteOrFilesToPDFExample : PSCExample @end

@interface PSCFullTextSearchExample () <PSPDFDocumentPickerControllerDelegate> {
    UISearchDisplayController *_searchDisplayController;
    BOOL _firstShown;
    BOOL _clearCacheNeeded;
}
@end

@implementation PSCFullTextSearchExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Full-Text Search";
        self.contentDescription = @"Use PSPDFDocumentPickerController to perform a full-text search across all sample documents.";
        self.category = PSCExampleCategoryTextExtraction;
        self.priority = 10;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFDocumentPickerController *documentSelector = [[PSPDFDocumentPickerController alloc] initWithDirectory:@"/Bundle/Samples" includeSubdirectories:YES library:PSPDFLibrary.defaultLibrary delegate:self];
    documentSelector.fullTextSearchEnabled = YES;
    return documentSelector;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentPickerControllerDelegate

- (void)documentPickerController:(PSPDFDocumentPickerController *)controller didSelectDocument:(PSPDFDocument *)document page:(NSUInteger)pageIndex searchString:(NSString *)searchString {
    PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
    pdfController.page = pageIndex;
    pdfController.rightBarButtonItems = @[pdfController.searchButtonItem, pdfController.outlineButtonItem, pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
    pdfController.additionalBarButtonItems = @[pdfController.openInButtonItem, pdfController.bookmarkButtonItem, pdfController.brightnessButtonItem, pdfController.printButtonItem, pdfController.emailButtonItem];
    [controller.navigationController pushViewController:pdfController animated:YES];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCConvertMarkupStringToPDFExample

@implementation PSCConvertMarkupStringToPDFExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Convert markup string to PDF";
        self.contentDescription = @"Convert a HTML-like string to PDF.";
        self.category = PSCExampleCategoryTextExtraction;
        self.priority = 20;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFAlertView *websitePrompt = [[PSPDFAlertView alloc] initWithTitle:@"Markup String" message:@"Experimental feature. Basic HTML is allowed."];
    websitePrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[websitePrompt textFieldAtIndex:0] setText:@"<br><br><br><h1>This is a <i>test</i> in <span style='color:red'>color.</span></h1>"];

    [websitePrompt setCancelButtonWithTitle:@"Cancel" block:nil];
    __weak PSPDFAlertView *weakAlert = websitePrompt;
    [websitePrompt addButtonWithTitle:@"Convert" block:^(NSInteger buttonIndex) {
        // Get data
        NSString *html = [weakAlert textFieldAtIndex:0].text ?: @"";
        NSURL *outputURL = PSCTempFileURLWithPathExtension(@"converted", @"pdf");

        // Create pdf (blocks).
        [PSPDFProcessor.defaultProcessor generatePDFFromHTMLString:html outputFileURL:outputURL options:@{PSPDFProcessorNumberOfPages : @(1), PSPDFProcessorDocumentTitle : @"Generated PDF"} error:NULL];

        // Generate document and show it.
        PSPDFDocument *document = [PSPDFDocument documentWithURL:outputURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

        [delegate.currentViewController.navigationController pushViewController:pdfController animated:YES];
    }];
    [websitePrompt show];
    return nil;
}

@end

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCConvertWebsiteOrFilesToPDFExample

@interface PSCConvertWebsiteOrFilesToPDFExample () {
    UISearchDisplayController *_searchDisplayController;
    BOOL _firstShown;
    BOOL _clearCacheNeeded;
}
@end

@implementation PSCConvertWebsiteOrFilesToPDFExample

- (instancetype)init {
    if ((self = [super init])) {
        self.title = @"Convert Website/Files to PDF";
        self.contentDescription = @"Use PSPDFProcessor to convert web sites or office documends directly to PDF.";
        self.category = PSCExampleCategoryTextExtraction;
        self.priority = 30;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    PSPDFAlertView *websitePrompt = [[PSPDFAlertView alloc] initWithTitle:@"Website/File URL" message:@"Convert websites or files to PDF (Word, Pages, Keynote, ...)"];
    websitePrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[websitePrompt textFieldAtIndex:0] setText:@"http://apple.com/iphone"];

    [websitePrompt setCancelButtonWithTitle:@"Cancel" block:nil];
    __weak PSPDFAlertView *weakAlert = websitePrompt;
    [websitePrompt addButtonWithTitle:@"Convert" block:^(NSInteger buttonIndex) {
        // get URL
        NSString *website = [weakAlert textFieldAtIndex:0].text ?: @"";
        if (![website.lowercaseString hasPrefix:@"http"]) website = [NSString stringWithFormat:@"http://%@", website];
        NSURL *URL = [NSURL URLWithString:website];
        NSURL *outputURL = PSCTempFileURLWithPathExtension(@"converted", @"pdf");
        //URL = [NSURL fileURLWithPath:PSPDFResolvePathNames(@"/Bundle/Samples/test2.key", nil)];

        // start the conversion
        PSPDFStatusHUDItem *status = [PSPDFStatusHUDItem indeterminateProgressWithText:@"Converting..."];
        [status setHUDStyle:PSPDFStatusHUDStyleGradient];
        [status pushAnimated:YES];

        NSDictionary *options = @{PSPDFProcessorPageBorderMargin : [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f)]};
        [PSPDFProcessor.defaultProcessor generatePDFFromURL:URL outputFileURL:outputURL options:options completionBlock:^(NSURL *fileURL, NSError *error) {
            if (error) {
                [status popAnimated:YES];
                [[[UIAlertView alloc] initWithTitle:@"Conversion failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] show];
            } else {
                // generate document and show it
                PSPDFStatusHUDItem *statusDone = [PSPDFStatusHUDItem successWithText:@"Done"];
                [statusDone pushAndPopWithDelay:2.0f animated:YES];
                [status popAnimated:YES];

                PSPDFDocument *document = [PSPDFDocument documentWithURL:fileURL];
                PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];

                [delegate.currentViewController.navigationController pushViewController:pdfController animated:YES];
            }
        }];
    }];
    [websitePrompt enableReturnKeyForTextFieldAtIndex:0];
    [websitePrompt show];
    return nil;
}

@end
