//
//  PSPDFAlertView.h
//
//  Copyright 2011-2013 Peter Steinberger. All rights reserved.
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

/// Custom tintColor. Set to nil for the default style.
/// @note Because the alert view is displayed in it's own window, the appearance can only be set globally.
@property (nonatomic, strong) UIColor *tintColor UI_APPEARANCE_SELECTOR;

/// Show with tint color. Use to conveniently create a one-line alertView with the classic init methods.
- (void)showWithTintColor:(UIColor *)tintColor;

@end
