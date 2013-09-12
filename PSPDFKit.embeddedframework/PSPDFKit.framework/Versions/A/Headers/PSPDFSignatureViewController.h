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
extern NSString *const PSPDFSignatureControllerShouldSaveKey;
extern NSString *const PSPDFSignatureControllerTargetPointKey;

/// Delegate to be notified on signature actions.
@protocol PSPDFSignatureViewControllerDelegate <PSPDFOverridable>

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
/// @note Created after view has been loaded.
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
