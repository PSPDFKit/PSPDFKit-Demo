//
//  PSCTextExtractionExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCTextExtractionExample.h"
#import "PSCTabbedExampleViewController.h"
#import "PSCFileHelper.h"
#import "UINavigationController+PSCKeyboardDismissal.h"
#import <objc/runtime.h>

@interface PSCTextExtractionFullTextSearchExample () <PSPDFDocumentPickerControllerDelegate> {
    UISearchDisplayController *_searchDisplayController;
    BOOL _firstShown;
    BOOL _clearCacheNeeded;
}
@end

@interface PSCTextExtractionConvertWebsiteOrFilesToPDFExample () <UITextFieldDelegate> {
    UISearchDisplayController *_searchDisplayController;
    BOOL _firstShown;
    BOOL _clearCacheNeeded;
}
@end

const char PSCShowDocumentSelectorOpenInTabbedControllerKey;
const char PSCAlertViewKey;

@implementation PSCTextExtractionFullTextSearchExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Full-Text Search";
        self.category = PSCExampleCategoryTextExtraction;
        self.priority = 10;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFDocumentPickerController *documentSelector = [[PSPDFDocumentPickerController alloc] initWithDirectory:@"/Bundle/Samples" includeSubdirectories:YES library:PSPDFLibrary.defaultLibrary delegate:self];
    documentSelector.fullTextSearchEnabled = YES;
    return documentSelector;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSPDFDocumentPickerControllerDelegate

- (void)documentPickerController:(PSPDFDocumentPickerController *)controller didSelectDocument:(PSPDFDocument *)document page:(NSUInteger)pageIndex searchString:(NSString *)searchString {
    BOOL showInGrid = [objc_getAssociatedObject(controller, &PSCShowDocumentSelectorOpenInTabbedControllerKey) boolValue];
    
    // add fade transition for navigationBar.
    [controller.navigationController.navigationBar.layer addAnimation:PSCFadeTransition() forKey:kCATransition];
    
    if (showInGrid) {
        // create controller and merge new documents with last saved state.
        PSPDFTabbedViewController *tabbedViewController = [PSCTabbedExampleViewController new];
        [tabbedViewController restoreStateAndMergeWithDocuments:@[document]];
        tabbedViewController.pdfController.page = pageIndex;
        [controller.navigationController pushViewController:tabbedViewController animated:YES];
    }else {
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        pdfController.page = pageIndex;
        pdfController.rightBarButtonItems = @[pdfController.searchButtonItem, pdfController.outlineButtonItem, pdfController.annotationButtonItem, pdfController.viewModeButtonItem];
        pdfController.additionalBarButtonItems = @[pdfController.openInButtonItem, pdfController.bookmarkButtonItem, pdfController.brightnessButtonItem, pdfController.printButtonItem, pdfController.emailButtonItem];
        [controller.navigationController pushViewController:pdfController animated:YES];
    }
}

@end

@implementation PSCTextExtractionConvertMarkupStringToPDFExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Convert markup string to PDF";
        self.category = PSCExampleCategoryTextExtraction;
        self.priority = 20;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFAlertView *websitePrompt = [[PSPDFAlertView alloc] initWithTitle:@"Markup String" message:@"Experimental feature. Basic HTML is allowed."];
    websitePrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[websitePrompt textFieldAtIndex:0] setText:@"<br><br><br><h1>This is a <i>test</i> in <span style='color:red'>color.</span></h1>"];
    
    [websitePrompt setCancelButtonWithTitle:@"Cancel" block:nil];
    [websitePrompt addButtonWithTitle:@"Convert" block:^{
        // get data
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        NSString *html = [websitePrompt textFieldAtIndex:0].text ?: @"";
#pragma clang diagnostic pop
        NSURL *outputURL = PSCTempFileURLWithPathExtension(@"converted", @"pdf");
        
        // create pdf (blocking)
        [[PSPDFProcessor defaultProcessor] generatePDFFromHTMLString:html outputFileURL:outputURL options:@{PSPDFProcessorNumberOfPages : @(1), PSPDFProcessorDocumentTitle : @"Generated PDF"}];
        
        // generate document and show it
        PSPDFDocument *document = [PSPDFDocument documentWithURL:outputURL];
        PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
        
        [delegate.currentViewController.navigationController pushViewController:pdfController animated:YES];
        
    }];
    [websitePrompt show];
    return nil;
}

@end

@implementation PSCTextExtractionConvertWebsiteOrFilesToPDFExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Convert Website/Files to PDF";
        self.category = PSCExampleCategoryTextExtraction;
        self.priority = 30;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    PSPDFAlertView *websitePrompt = [[PSPDFAlertView alloc] initWithTitle:@"Website/File URL" message:@"Convert websites or files to PDF (Word, Pages, Keynote, ...)"];
    websitePrompt.alertViewStyle = UIAlertViewStylePlainTextInput;
    [[websitePrompt textFieldAtIndex:0] setText:@"http://apple.com/iphone"];
    
    [websitePrompt setCancelButtonWithTitle:@"Cancel" block:nil];
    [websitePrompt addButtonWithTitle:@"Convert" block:^{
        // get URL
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-retain-cycles"
        NSString *website = [websitePrompt textFieldAtIndex:0].text ?: @"";
#pragma clang diagnostic pop
        if (![website.lowercaseString hasPrefix:@"http"]) website = [NSString stringWithFormat:@"http://%@", website];
        NSURL *URL = [NSURL URLWithString:website];
        NSURL *outputURL = PSCTempFileURLWithPathExtension(@"converted", @"pdf");
        //URL = [NSURL fileURLWithPath:PSPDFResolvePathNames(@"/Bundle/Samples/test2.key", nil)];
        
        // start the conversion
        [PSPDFProgressHUD showWithStatus:@"Converting..." maskType:PSPDFProgressHUDMaskTypeGradient];
        [PSPDFProcessor.defaultProcessor generatePDFFromURL:URL outputFileURL:outputURL options:nil completionBlock:^(NSURL *fileURL, NSError *error) {
            if (error) {
                [PSPDFProgressHUD dismiss];
                [[[UIAlertView alloc] initWithTitle:@"Conversion failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }else {
                // generate document and show it
                [PSPDFProgressHUD showSuccessWithStatus:@"Finished"];
                PSPDFDocument *document = [PSPDFDocument documentWithURL:fileURL];
                PSPDFViewController *pdfController = [[PSPDFViewController alloc] initWithDocument:document];
                
                [delegate.currentViewController.navigationController pushViewController:pdfController animated:YES];
            }
        }];
    }];
    [[websitePrompt textFieldAtIndex:0] setDelegate:self]; // enable return key
    objc_setAssociatedObject([websitePrompt textFieldAtIndex:0], &PSCAlertViewKey, websitePrompt, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [websitePrompt show];
    return nil;
}

@end
