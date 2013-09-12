//
//  PSPDFSignatureStore.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@class PSPDFSignatureSelectorViewController, PSPDFInkAnnotation;

/// Allows to securely store signatures (as ink annotations) in the keychain.
@interface PSPDFSignatureStore : NSObject

/// Shared object.
+ (instancetype)sharedSignatureStore;

/// Add signature to store.
- (void)addSignature:(PSPDFInkAnnotation *)signature;

/// Remove signature from store.
- (BOOL)removeSignature:(PSPDFInkAnnotation *)signature;

/// Access the saved signatures (PSPDFInkAnnotation objects).
@property (atomic, copy) NSArray *signatures;

/// If this is set to NO, PSPDFKit will not differentiate between My Signature/Customer signature.
/// Defaults to YES.
@property (atomic, assign) BOOL signatureSavingEnabled;

/// If enabled, the signature feature will show a menu with a customer signature (will not be saved)
/// Defaults to YES.
@property (atomic, assign) BOOL customerSignatureFeatureEnabled;

@end
