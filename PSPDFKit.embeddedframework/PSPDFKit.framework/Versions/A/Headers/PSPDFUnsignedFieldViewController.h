//
//  PSPDFUnsignedFieldViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFSignatureFormElement.h"
#import "PSPDFDigitalSignatureVerificationController.h"
#import "PSPDFBaseTableViewController.h"

@class PSPDFUnsignedFieldViewController;

@protocol PSPDFUnsignedFieldViewControllerDelegate <NSObject>

- (void)unsignedFieldViewControllerRequestsInkSignature:(PSPDFUnsignedFieldViewController *)unsignedFieldController;

@end

@interface PSPDFUnsignedFieldViewController : PSPDFBaseTableViewController

- (id)initWithSignatureField:(PSPDFSignatureFormElement *)signatureField;

// Delegate
@property (nonatomic, weak) id <PSPDFUnsignedFieldViewControllerDelegate> delegate;

// The signature field.
@property (nonatomic, strong, readonly) PSPDFSignatureFormElement *signatureField;

/// Allows a simple ink signature to "sign". (not a digital signature)
@property (nonatomic, assign) BOOL allowInkSignature;

@end
