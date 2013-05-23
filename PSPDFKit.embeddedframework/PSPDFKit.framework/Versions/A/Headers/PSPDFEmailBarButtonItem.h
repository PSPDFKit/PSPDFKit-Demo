//
//  PSPDFEmailBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBarButtonItem.h"
#import <MessageUI/MessageUI.h>

@class PSPDFActionSheet;

typedef NS_OPTIONS(NSUInteger, PSPDFEmailSendOptions) {
    PSPDFEmailSendCurrentPageOnly              = 1<<0, // Only page set in .page of PSPDFViewController.
    PSPDFEmailSendCurrentPageOnlyFlattened     = 1<<1,
    PSPDFEmailSendVisiblePages                 = 1<<2, // All visible pages (is ignored if only one page is visible).
    PSPDFEmailSendVisiblePagesFlattened        = 1<<3,
    PSPDFEmailSendMergedFilesIfNeeded          = 1<<4,
    PSPDFEmailSendMergedFilesIfNeededFlattened = 1<<5, // Will merge your annotations, even if you have just one file.
    PSPDFEmailSendOriginalDocumentFiles        = 1<<6
};

/**
 Allows to send the whole PDF or the visible page(s) as PDF.

 If the PDF consists of multiple files, a temporary PDF will be created merging all pages.
 To figure out the name, PSPDFDocument's fileNamesWithDataDictionary will be used.

 IF you want to customize the body text, use the shouldShowController: delegate in PSPDFViewController. To check that this mail controller was created via PSPDFEmailBarButtonItem, compare the delegate destination.
 */
@interface PSPDFEmailBarButtonItem : PSPDFBarButtonItem <MFMailComposeViewControllerDelegate>

/**
 Control what data is sent. Defaults to PSPDFEmailSendVisiblePagesFlattened|PSPDFEmailSendMergedFilesIfNeeded|PSPDFEmailSendMergedFilesIfNeededFlattened.
 If only one option is set here, no menu will be displayed.

 ***Flattened control if annotations should be flattened.
 Annotations that are not flattened are not displayed in Mobile Mail/Mobile Safari.
 Note that annotations will be removed if this is set to NO for every option but PSPDFEmailSendOriginalDocumentFiles.

 PSPDFEmailSendMergedFilesIfNeeded will be equal to PSPDFEmailSendOriginalDocumentFiles if the document has just one document provider.
 */
@property (nonatomic, assign) PSPDFEmailSendOptions sendOptions;

/// Allows customization of the mail compose controller before it's displayed. (e.g. set custom body text)
@property (nonatomic, copy) void (^mailComposeViewControllerCustomizationBlock)(MFMailComposeViewController *);

/// Allows to add custom buttons in the action sheet. Will be called before the Cancel button is added.
@property (nonatomic, copy) void (^actionSheetCustomizationBlock)(PSPDFActionSheet *);

@end

@interface PSPDFEmailBarButtonItem (SubclassingHooks)

// Merges/flattens/attaches the files.
- (void)attachDocumentToMailController:(MFMailComposeViewController *)mailViewController withMode:(PSPDFEmailSendOptions)mode completionBlock:(void (^)(BOOL success))completionBlock;

// Finally shows the email controller.
- (void)showEmailControllerWithSendOptions:(PSPDFEmailSendOptions)sendOptions sender:(id)sender animated:(BOOL)animated;

// Hook to customize the fileName generation.
- (NSString *)fileNameForPage:(NSUInteger)pageIndex sendOptions:(PSPDFEmailSendOptions)sendOptions;

// Action sheet used internally if there are different options.
@property (nonatomic, strong) UIActionSheet *actionSheet;

@end
