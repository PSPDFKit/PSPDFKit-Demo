//
//  PSPDFEmailBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFBarButtonItem.h"
#import <MessageUI/MessageUI.h>

typedef NS_OPTIONS(NSUInteger, PSPDFEmailSendOptions) {
    PSPDFEmailSendCurrentPageOnly              = 1<<0, // only page set in .page of PSPDFViewController
    PSPDFEmailSendCurrentPageOnlyFlattened     = 1<<1,
    PSPDFEmailSendVisiblePages                 = 1<<2, // all visible pages (is ignored if only one page is visible)
    PSPDFEmailSendVisiblePagesFlattened        = 1<<3,
    PSPDFEmailSendMergedFilesIfNeeded          = 1<<4,
    PSPDFEmailSendMergedFilesIfNeededFlattened = 1<<5, // Will merge your annotations, even if you have just one file.
    PSPDFEmailSendOriginalDocumentFiles        = 1<<6
};

/**
 Allows to send the whole PDF or the visible page(s) as PDF.
 
 If the PDF consists of multple files, a temporary PDF will be created merging all pages.
 
 To figure out the name, PSPDFDOcument's fileNamesWithDataDictionary will be used.
 */
@interface PSPDFEmailBarButtonItem : PSPDFBarButtonItem

/**
 Control what data is sent. Defaults to PSPDFEmailSendVisiblePagesFlattened | PSPDFEmailSendMergedFilesIfNeeded | PSPDFEmailSendMergedFilesIfNeededFlattened.
 If only one option is set here, no menu will be displayed.

 ***Flattened control if annotations should be flattened.
 Annotations that are not flattened are not displayed in Mobile Mail/Mobile Safari.
 Note that annotations will be removed if this is set to NO for every option but PSPDFEmailSendOriginalDocumentFiles.
 
 PSPDFEmailSendMergedFilesIfNeeded will be equal to PSPDFEmailSendOriginalDocumentFiles if the document has just one document provider.
 */
@property (nonatomic, assign) PSPDFEmailSendOptions sendOptions;

@end

@interface PSPDFEmailBarButtonItem (SubclassingHooks)

// merges/flattens/attaches the files.
- (void)attachDocumentToMailController:(MFMailComposeViewController *)mailViewController withMode:(PSPDFEmailSendOptions)mode completionBlock:(void (^)(BOOL success))completionBlock;

// finally shows the email controller.
- (void)showEmailControllerWithSendOptions:(PSPDFEmailSendOptions)sendOptions sender:(id)sender animated:(BOOL)animated;

// Hook to customize the fileName generation.
- (NSString *)fileNameForPage:(NSUInteger)pageIndex sendOptions:(PSPDFEmailSendOptions)sendOptions;

// action sheet used internally if there are different options.
@property (nonatomic, strong) UIActionSheet *actionSheet;

@end

// deprecated flag support
__attribute__ ((deprecated)) extern const NSUInteger PSPDFEmailSendAskUser; // equivalent to PSPDFEmailSendVisiblePagesFlattened | PSPDFEmailSendMergedFilesIfNeeded;
