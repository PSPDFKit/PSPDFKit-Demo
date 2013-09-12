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
#import "PSPDFDocumentSharingViewController.h"

/**
 Allows to send the whole PDF or the visible page(s) as PDF.

 If the PDF consists of multiple files, a temporary PDF will be created merging all pages.
 To figure out the name, PSPDFDocument's fileNamesWithDataDictionary will be used.

 IF you want to customize the body text, use the shouldShowController: delegate in PSPDFViewController. To check that this mail controller was created via PSPDFEmailBarButtonItem, compare the delegate destination.
 */
@interface PSPDFEmailBarButtonItem : PSPDFBarButtonItem <PSPDFDocumentSharingViewControllerDelegate, MFMailComposeViewControllerDelegate>

/**
 Control what data is sent. Defaults to PSPDFDocumentSharingOptionCurrentPageOnly|PSPDFDocumentSharingOptionAllPages|PSPDFDocumentSharingOptionEmbedAnnotations|PSPDFDocumentSharingOptionFlattenAnnotations|PSPDFDocumentSharingOptionAnnotationsSummary|PSPDFDocumentSharingOptionOfferMergeFiles.
 If only one option is set here, no menu will be displayed.

 *Flattened controls if annotations should be flattened.
 Annotations that are not flattened are not displayed in Mobile Mail/Mobile Safari (partly as of iOS 7).
 */
@property (nonatomic, assign) PSPDFDocumentSharingOptions sendOptions;

/// Allows customization of the mail compose controller before it's displayed. (e.g. set custom body text)
@property (nonatomic, copy) void (^mailComposeViewControllerCustomizationBlock)(MFMailComposeViewController *);

@end

@interface PSPDFEmailBarButtonItem (SubclassingHooks)

// Shows the email controller.
- (void)showEmailControllerWithSendOptions:(PSPDFDocumentSharingOptions)sendOptions dataArray:(NSArray *)dataArray fileNames:(NSArray *)fileNames sender:(id)sender animated:(BOOL)animated;

@end
