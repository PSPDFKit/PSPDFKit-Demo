//
//  PSPDFSignatureStore.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@class PSPDFInkAnnotation;

/// Allows to securely store ink signatures (as ink annotations) in the keychain.
/// Supports `NSSecureCoding` since this is part of the `PSPDFConfiguration` object.
@protocol PSPDFSignatureStore <NSObject, NSSecureCoding>

/// Designated initializer.
/// `storeName` can be used to differentiate between different stores.
- (instancetype)initWithStoreName:(NSString *)storeName;

/// Add signature to store.
- (void)addSignature:(PSPDFInkAnnotation *)signature;

/// Remove signature from store.
- (BOOL)removeSignature:(PSPDFInkAnnotation *)signature;

/// Access the saved signatures (`PSPDFInkAnnotation` objects).
@property (nonatomic, copy) NSArray *signatures;

/// The store name used for the keychain storage.
@property (nonatomic, copy, readonly) NSString *storeName;

@end

// The default store name used in the `PSPDFKeychainSignatureStore`.
extern NSString *const PSPDFKeychainSignatureStoreDefaultStoreName;

// Default signature store implementation that uses the keychain.
// `storeName` is used as the service name in the keychain.
@interface PSPDFKeychainSignatureStore : NSObject <PSPDFSignatureStore> @end
