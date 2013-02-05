//
//  PSPDFPasswordView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFDocument, PSPDFPasswordView;

/// Delegate for the password unlock view.
@protocol PSPDFPasswordViewDelegate <NSObject>

/// did unlock with password successfully.
- (void)passwordView:(PSPDFPasswordView *)passwordView didUnlockWithPassword:(NSString *)password;

@optional

/// failed to unlock the document.
- (void)passwordView:(PSPDFPasswordView *)passwordView didFailToUnlockWithPassword:(NSString *)password;

/// Should perform unlock? Return false to cancel.
- (BOOL)passwordView:(PSPDFPasswordView *)passwordView shouldlUnlockWithPassword:(NSString *)password;

// will try to unlock with password
- (void)passwordView:(PSPDFPasswordView *)passwordView willUnlockWithPassword:(NSString *)password;

@end


/// Shows a interface to enter a password for locked/encrypted pdf's.
@interface PSPDFPasswordView : UIView <UITextFieldDelegate>

- (BOOL)becomeFirstResponder;

/// Document. Can be changed.
@property (nonatomic, weak) PSPDFDocument *document;

/// Delegate to control the password unlock.
@property (nonatomic, weak) IBOutlet id<PSPDFPasswordViewDelegate> delegate;

/// Shake if password is not accepted.
@property (nonatomic, assign) BOOL shakeOnError;

@end

@interface PSPDFPasswordView (SubclassingHooks)

/// Password text field.
@property (nonatomic, strong, readonly) UITextField *passwordField;

@end
