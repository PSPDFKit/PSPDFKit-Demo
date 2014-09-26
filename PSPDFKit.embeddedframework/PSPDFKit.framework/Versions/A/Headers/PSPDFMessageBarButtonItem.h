//
//  PSPDFMessageBarButtonItem.h
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
#import "PSPDFDocumentSharingViewController.h"
#import <MessageUI/MessageUI.h>

/// Presents a `MFMessageComposeViewController`.
/// Allows to share via iMessage/SMS on the devices supporting this.
/// @note Depending on `sendOptions`, the `PSPDFDocumentSharingViewController` will be presented first.
@interface PSPDFMessageBarButtonItem : PSPDFBarButtonItem <PSPDFDocumentSharingViewControllerDelegate, MFMessageComposeViewControllerDelegate>

/// The send options for iMessage/SMS sharing.
@property (nonatomic, assign) PSPDFDocumentSharingOptions sendOptions;

@end
