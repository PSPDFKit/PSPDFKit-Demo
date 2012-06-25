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
@interface PSPDFAlertView : UIAlertView

/// @name Initialization

/// Default initializer.
- (id)initWithTitle:(NSString *)title;
- (id)initWithTitle:(NSString *)title message:(NSString *)message;


/// @name Adding Buttons

/// Add a cancel button. (use only once!)
- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)())block;

/// Add regular button.
- (void)addButtonWithTitle:(NSString *)title block:(void (^)())block;

@end
