//
//  PSPDFSignedFormElementViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFSignatureStatus.h"
#import "PSPDFBaseTableViewController.h"

@class PSPDFDocument;
@class PSPDFSignatureFormElement;

@protocol PSPDFSignedFormElementViewControllerDelegate;

@interface PSPDFSignedFormElementViewController : PSPDFBaseTableViewController

/// Inits the signed view controller with a signature form element. This is
/// usually done by the form element itself. You can retrieve the current
/// view controller from the elements unsignedViewController property.
- (instancetype)initWithSignatureFormElement:(PSPDFSignatureFormElement *)element NS_DESIGNATED_INITIALIZER;

/// The signature form element the controller was initialized with
@property (nonatomic, weak, readonly) PSPDFSignatureFormElement *formElement;

/// Verifies the signature. You can check if the signature is valid by using
/// the returned signature status' severity flag.
- (PSPDFSignatureStatus *)verifySignature:(NSError *__autoreleasing*)error;

/// The signed form element view controller delegate
@property (nonatomic, weak) id<PSPDFSignedFormElementViewControllerDelegate> delegate;

@end

@protocol PSPDFSignedFormElementViewControllerDelegate <NSObject>
@optional

- (void)signedFormElementViewController:(PSPDFSignedFormElementViewController *)controller removedSignatureFromDocument:(PSPDFDocument *)document;

@end
