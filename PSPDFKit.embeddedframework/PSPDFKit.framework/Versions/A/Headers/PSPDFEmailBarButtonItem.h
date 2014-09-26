//
//  PSPDFEmailBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
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
 To figure out the name, `PSPDFDocument's` `fileNamesWithDataDictionary` will be used.

 IF you want to customize the body text, use the `shouldShowController:` delegate in `PSPDFViewController`. To check that this mail controller was created via `PSPDFEmailBarButtonItem`, compare the delegate destination.

  @note Depending on `sendOptions`, the `PSPDFDocumentSharingViewController` will be presented first.
 */
@interface PSPDFEmailBarButtonItem : PSPDFBarButtonItem <PSPDFDocumentSharingViewControllerDelegate, MFMailComposeViewControllerDelegate>

/**
 Control what data is sent. Defaults to `PSPDFDocumentSharingOptionCurrentPageOnly|PSPDFDocumentSharingOptionAllPages|PSPDFDocumentSharingOptionEmbedAnnotations|PSPDFDocumentSharingOptionFlattenAnnotations|PSPDFDocumentSharingOptionAnnotationsSummary|PSPDFDocumentSharingOptionOfferMergeFiles`.

 If only one option is set here, no menu will be displayed.

 @note Annotations that are not flattened will not displayed in Mobile Mail/Mobile Safari.
 (This is a technical limitation and Apple adde partial but mostly incomplete support since iOS 7)
 */
@property (nonatomic, assign) PSPDFDocumentSharingOptions sendOptions;

@end

@interface PSPDFEmailBarButtonItem (SubclassingHooks)

// Shows the email controller.
- (void)showEmailControllerWithSendOptions:(PSPDFDocumentSharingOptions)sendOptions dataArray:(NSArray *)dataArray fileNames:(NSArray *)fileNames sender:(id)sender annotationSummary:(NSAttributedString *)annotationSummary animated:(BOOL)animated;

// Keeps a reference to the mail compose view controller, if visible.
@property (nonatomic, weak, readonly) MFMailComposeViewController *mailComposeViewController;

@end
