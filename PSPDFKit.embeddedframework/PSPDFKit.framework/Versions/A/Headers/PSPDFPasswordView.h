//
//  PSPDFPasswordView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class PSPDFDocument, PSPDFPasswordView;

/// Delegate for the password unlock view.
@protocol PSPDFPasswordViewDelegate <NSObject>

/// Did unlock with password successfully.
- (void)passwordView:(PSPDFPasswordView *)passwordView didUnlockWithPassword:(NSString *)password;

@optional

/// Failed to unlock the document.
- (void)passwordView:(PSPDFPasswordView *)passwordView didFailToUnlockWithPassword:(NSString *)password;

/// Should perform unlock? Return false to cancel.
- (BOOL)passwordView:(PSPDFPasswordView *)passwordView shouldUnlockWithPassword:(NSString *)password;

/// Will try to unlock with password.
- (void)passwordView:(PSPDFPasswordView *)passwordView willUnlockWithPassword:(NSString *)password;

@end


/// Shows a interface to enter a password for locked/encrypted PDF's.
/// Call `becomeFirstResponder` to show the keyboard.
@interface PSPDFPasswordView : UIView <UITextFieldDelegate>

/// The current document.
@property (nonatomic, strong) PSPDFDocument *document;

/// Delegate to control the password unlock.
@property (nonatomic, weak) IBOutlet id<PSPDFPasswordViewDelegate> delegate;

/// Shake if password is not accepted. Defaults to YES.
@property (nonatomic, assign) BOOL shakeOnError;

@end

@interface PSPDFPasswordView (SubclassingHooks)

// Password text field.
@property (nonatomic, strong, readonly) UITextField *passwordField;

// Status label below the password text field.
@property (nonatomic, strong, readonly) UILabel *statusLabel;

// Unlock button (set as passwordField.rightView)
@property (nonatomic, strong, readonly) UIButton *unlockButton;

@end
