//
//  PSPDFUnsignedFormElementViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import "PSPDFBaseTableViewController.h"

@class PSPDFDocument, PSPDFSignatureFormElement;
@protocol PSPDFUnsignedFormElementViewControllerDelegate;

@interface PSPDFUnsignedFormElementViewController : PSPDFBaseTableViewController

/// Inits the unsigned view controller with a signature form element. This is
/// usually done by the form element itself. You can retrieve the current
/// view controller from the elements unsignedViewController property.
- (instancetype)initWithSignatureFormElement:(PSPDFSignatureFormElement *)element NS_DESIGNATED_INITIALIZER;

/// The signature form element the controller was initialized with
@property (nonatomic, weak, readonly) PSPDFSignatureFormElement *formElement;

/// Whether or not this field allows ink signatures
@property (nonatomic, assign) BOOL allowInkSignature;

/// The unsigned form element view controller delegate
@property (nonatomic, weak) id<PSPDFUnsignedFormElementViewControllerDelegate> delegate;

@end


@protocol PSPDFUnsignedFormElementViewControllerDelegate <NSObject>

- (void)unsignedFormElementViewControllerRequestsInkSignature:(PSPDFUnsignedFormElementViewController *)controller;

@optional

- (void)unsignedFormElementViewController:(PSPDFUnsignedFormElementViewController *)controller signedDocument:(PSPDFDocument *)document error:(NSError *)error;

@end
