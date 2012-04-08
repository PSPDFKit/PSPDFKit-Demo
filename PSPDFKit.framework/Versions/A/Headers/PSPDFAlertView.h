//
//  PSPDFAlertView.h
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//
//  Loosely based on Landon Fullers "Using Blocks", Plausible Labs Cooperative.
//  http://landonf.bikemonkey.org/code/iphone/Using_Blocks_1.20090704.html
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// Helper to add block features to UIAlertView.
/// After block has been executed, it is set to nil, breaking potential retain cycles.
@interface PSPDFAlertView : NSObject

/// @name Initialization

/// Create alertview with title, no message.
+ (PSPDFAlertView *)alertWithTitle:(NSString *)title;

/// Create alertview with title and message.
+ (PSPDFAlertView *)alertWithTitle:(NSString *)title message:(NSString *)message;

/// Default initializer.
- (id)initWithTitle:(NSString *)title message:(NSString *)message;


/// @name Adding Buttons

/// Add a cancel button. (use only once!)
- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block;

/// Add regular button.
- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block;

/// Show AlerView.
- (void)show;


/// @name Dismiss / Internal Access

/// Dismisses AlertView, calls clock ode set at buttonIndex.
- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated;

/// Access to the internal UIAlertView.
@property (nonatomic, strong) UIAlertView *alertView;

@end
