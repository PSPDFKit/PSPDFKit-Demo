//
//  PSPDFAlertView.h
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

/// Helper to add block features to UIAlertView.
/// After block has been executed, it is set to nil, breaking potential retain cycles.
@interface PSPDFAlertView : UIAlertView

/// @name Initialization

/// Default initializer.
- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title message:(NSString *)message;

/// @name Adding Buttons

/// Add a cancel button. (use only once!)
- (NSInteger)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block;
- (NSInteger)setCancelButtonWithTitle:(NSString *)title extendedBlock:(void (^)(PSPDFAlertView *alert, NSInteger buttonIndex))block;

/// Add regular button.
- (NSInteger)addButtonWithTitle:(NSString *)title block:(void (^)())block;
- (NSInteger)addButtonWithTitle:(NSString *)title extendedBlock:(void (^)(PSPDFAlertView *alert, NSInteger buttonIndex))block;

/// @name Style

/// Custom alertViewTintColor. Set to nil for the default style.
/// @note Because the alert view is displayed in its own window, the appearance can only be set globally.
/// @warning alertViewTintColor is unavailable for iOS7+.
@property (nonatomic, strong) UIColor *alertViewTintColor UI_APPEARANCE_SELECTOR;

/// Show with tint color. Use to conveniently create a one-line alertView with the classic init methods.
/// @warning alertViewTintColor is unavailable for iOS7+.
- (void)showWithTintColor:(UIColor *)tintColor;

@end

@interface PSPDFAlertView (PSPDFSuperclassBlock)

- (id)initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... __attribute__((unavailable("Please use initWithTitle:")));

@end
