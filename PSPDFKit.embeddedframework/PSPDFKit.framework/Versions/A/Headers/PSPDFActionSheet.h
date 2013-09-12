//
//  PSPDFActionSheet.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"

/// Helper to add block features to UIActionSheet.
/// After block has been executed, it is set to nil, breaking potential retain cycles.
@interface PSPDFActionSheet : UIActionSheet

/// @name Initialization

/// Default initializer.
- (id)initWithTitle:(NSString *)title;

/// @name Adding Buttons

/// Adds a cancel button. Use only once.
- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)setCancelButtonWithTitle:(NSString *)title extendedBlock:(void (^)(PSPDFActionSheet *sheet, NSInteger buttonIndex))block;

/// Adds a destructive button. Use only once.
- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)setDestructiveButtonWithTitle:(NSString *)title extendedBlock:(void (^)(PSPDFActionSheet *sheet, NSInteger buttonIndex))block;

/// Add regular button.
- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)addButtonWithTitle:(NSString *)title extendedBlock:(void (^)(PSPDFActionSheet *sheet, NSInteger buttonIndex))block;

/// @name Properties and show/destroy

/// Count the buttons.
- (NSUInteger)buttonCount;

/// Is clever about the sender, uses fallbackView if sender is not usable (nil, or not UIBarButtonItem/UIView)
- (void)showWithSender:(id)sender fallbackView:(UIView *)view animated:(BOOL)animated;

/// Clears all blocks, breaks retain cycles. Automatically called once a button has been pressed.
- (void)destroy;

/// Call block when action sheet is about to be dismissed.
@property (nonatomic, copy) void (^willDismissBlock)(PSPDFActionSheet *sheet, NSInteger buttonIndex);

/// Call block when action sheet has been dismissed.
@property (nonatomic, copy) void (^didDismissBlock)(PSPDFActionSheet *sheet, NSInteger buttonIndex);

@end

@interface PSPDFActionSheet (PSPDFSuperclassBlock)

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... __attribute__((unavailable("Please use initWithTitle:")));

@end
