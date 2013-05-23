//
//  PSPDFSignatureViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFStyleable.h"
#import "PSPDFBaseViewController.h"
#import "PSPDFDrawView.h"

@class PSPDFSignatureViewController;

// Constants are used in the delegate and saved in userInfo.
extern NSString *const PSPDFSignatureControllerShouldSave;
extern NSString *const PSPDFSignatureControllerTargetPoint;

/// Delegate to be notified on signature actions.
@protocol PSPDFSignatureViewControllerDelegate <NSObject>

@optional

/// Cancel button has been pressed.
- (void)signatureViewControllerDidCancel:(PSPDFSignatureViewController *)signatureController;

/// Save/Done button has been pressed.
- (void)signatureViewControllerDidSave:(PSPDFSignatureViewController *)signatureController;

@end


/// Allows adding signatures or drawings as ink annotations.
@interface PSPDFSignatureViewController : PSPDFBaseViewController <PSPDFStyleable>

/// Designated initializer.
- (id)init;

/// Lines of the drawView.
@property (nonatomic, strong, readonly) NSArray *lines;

/// Signature controller delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFSignatureViewControllerDelegate> delegate;

/// Internally used draw view. Allows line color/thickness customization.
@property (nonatomic, strong, readonly) PSPDFDrawView *drawView;

/// Save additional properties here. This will not be used by the signature controller.
@property (nonatomic, copy) NSDictionary *userInfo;

@end


@interface PSPDFSignatureViewController (SubclassingHooks)

/// Internally used drawView.
@property (nonatomic, strong, readonly) PSPDFDrawView *drawView;

// To make custom buttons.
- (void)cancel:(id)sender;

- (void)done:(id)sender;

@end


@class PSPDFSignatureSelectorViewController, PSPDFInkAnnotation;

/// Delegate to be notified when the PSPDFSignatureSelectorViewController has a valid selection.
@protocol PSPDFSignatureSelectorViewControllerDelegate <NSObject>

/// A signature has been selected.
- (void)signatureSelectorViewController:(PSPDFSignatureSelectorViewController *)signatureSelectorController didSelectSignature:(PSPDFInkAnnotation *)signature;

/// The 'add' button has been pressed.
- (void)signatureSelectorViewControllerWillCreateNewSignature:(PSPDFSignatureSelectorViewController *)signatureSelectorController;

@end


/// Shows a list of signatures to select one.
/// Will show up in landscape on iOS6 (preferredInterfaceOrientationForPresentation)
@interface PSPDFSignatureSelectorViewController : UITableViewController <PSPDFStyleable>

/// Designated initializer.
- (id)initWithSignatures:(NSArray *)signatures;

/// Signatures that are being displayed.
@property (nonatomic, copy, readonly) NSArray *signatures;

/// Delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFSignatureSelectorViewControllerDelegate> delegate;

/// Save additional properties here. This will not be used by the signature selector controller.
@property (nonatomic, copy) NSDictionary *userInfo;

@end


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
