//
//  PSPDFEmailBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFBarButtonItem.h"
#import <MessageUI/MessageUI.h>

typedef NS_ENUM(NSUInteger, PSPDFEmailSendOptions) {
    PSPDFEmailSendAskUser, // PSPDFEmailSendVisiblePages or PSPDFEmailSendMergedFilesIfNeeded
    PSPDFEmailSendCurrentPageOnly,
    PSPDFEmailSendVisiblePages,
    PSPDFEmailSendOriginalDocumentFiles,
    PSPDFEmailSendMergedFilesIfNeeded
};

/**
 Allows to send the whole PDF or the visible page(s) as PDF.
 
 If the PDF consists of multple files, a temporary PDF will be created merging all pages.
 
 To figure out the name, PSPDFDOcument's fileNamesWithDataDictionary will be used.
 */
@interface PSPDFEmailBarButtonItem : PSPDFBarButtonItem <MFMailComposeViewControllerDelegate>

/// Control what data is sent. Defaults to PSPDFEmailSendAskUser.
@property (nonatomic, assign) PSPDFEmailSendOptions sendOptions;

/**
 Control if annotations should be flattened. Defaults to YES.
 
 Annotations that are not flattened are not displayed in Mobile Mail/Mobile Safari.

 Currently this will be ignored for PSPDFEmailSendOriginalDocumentFiles.
 Note that annotations will be removed if this is set to NO for every option but PSPDFEmailSendOriginalDocumentFiles.
 Contact me if this is a limitation for you.
 */
@property (nonatomic, assign) BOOL flattenAnnotations;

@end


@interface PSPDFEmailBarButtonItem (SubclassingHooks)

// merges/flattens/attaches the files.
- (BOOL)attachDocumentToMailController:(MFMailComposeViewController *)mailViewController withMode:(PSPDFEmailSendOptions)mode;

// finally shows the email controller.
- (id)showEmailControllerWithSendOptions:(PSPDFEmailSendOptions)sendOptions animated:(BOOL)animated;

// Hook to customize the fileName generation.
- (NSString *)fileNameForPage:(NSUInteger)pageIndex sendOptions:(PSPDFEmailSendOptions)sendOptions;

// action sheet used internally if there are different options.
@property (nonatomic, strong) UIActionSheet *actionSheet;

@end