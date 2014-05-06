//
//  PSPDFActionSheet.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

/// Helper to add block features to `UIActionSheet`.
/// After block has been executed, it is set to nil, breaking potential retain cycles.
@interface PSPDFActionSheet : UIActionSheet

/// @name Initialization

/// Default initializer.
- (id)initWithTitle:(NSString *)title;

/// @name Adding Buttons

/// Adds a cancel button. Use only once.
- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)(NSInteger buttonIndex))block;

/// Adds a destructive button. Use only once.
- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)(NSInteger buttonIndex))block;

/// Add regular button.
- (void)addButtonWithTitle:(NSString *)title block:(void (^)(NSInteger buttonIndex))block;

/// @name Properties and show/destroy

/// Count the buttons.
- (NSUInteger)buttonCount;

/// Is clever about the sender, uses fallbackView if sender is not usable (nil, or not `UIBarButtonItem`/`UIView`)
- (void)showWithSender:(id)sender fallbackView:(UIView *)view animated:(BOOL)animated;

/// A `UIActionSheet` can always be cancelled, even if no cancel button is present.
/// Use `allowsTapToDismiss` to block cancellation on tap. The control might still be cancelled from OS events.
- (void)addCancelBlock:(void (^)(NSInteger buttonIndex))cancelBlock;

/// Add block that is called after the sheet will be dismissed (before animation).
/// @note In difference to the action sheet, this is called BEFORE any of the block-based button actions are called.
- (void)addWillDismissBlock:(void (^)(NSInteger buttonIndex))willDismissBlock;

/// Add block that is called after the sheet has been dismissed (after animation).
- (void)addDidDismissBlock:(void (^)(NSInteger buttonIndex))didDismissBlock;

/// Allows to be dismissed by tapping outside? Defaults to YES (UIActionSheet default)
@property (nonatomic, assign) BOOL allowsTapToDismiss;

@end

@interface PSPDFActionSheet (PSPDFSuperclassBlock)

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... __attribute__((unavailable("Please use initWithTitle:")));

@end
