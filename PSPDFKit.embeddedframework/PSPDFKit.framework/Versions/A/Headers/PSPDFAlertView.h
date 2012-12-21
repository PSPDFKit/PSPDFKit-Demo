//
//  PSPDFAlertView.h
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
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
- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)setCancelButtonWithTitle:(NSString *)title extendedBlock:(void (^)(PSPDFAlertView *alert, NSInteger buttonIndex))block;

/// Add regular button.
- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block;
- (void)addButtonWithTitle:(NSString *)title extendedBlock:(void (^)(PSPDFAlertView *alert, NSInteger buttonIndex))block;

/// @name Style

/// Custom tintColor. Set to nil for the default style.
@property (nonatomic, strong) UIColor *tintColor;

/// Show with tint color. Use to conveniently create a one-line alertView with the classic init methods.
- (void)showWithTintColor:(UIColor *)tintColor;

@end
