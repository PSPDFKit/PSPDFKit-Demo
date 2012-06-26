//
//  PSPDFActionSheet.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// Helper to add block features to UIActionSheet.
/// After block has been executed, it is set to nil, breaking potential retain cycles.
@interface PSPDFActionSheet : UIActionSheet

/// @name Inititalization

/// Default initializer.
- (id)initWithTitle:(NSString *)title;


/// @name Adding Buttons

/// Adds a cancel button. Use only once.
- (void)setCancelButtonWithTitle:(NSString *) title block:(void (^)())block;

/// Adds a destructive button. Use only once.
- (void)setDestructiveButtonWithTitle:(NSString *) title block:(void (^)())block;

/// Add regular button.
- (void)addButtonWithTitle:(NSString *) title block:(void (^)())block;
<<<<<<< HEAD
=======


/// @name Show ActionSheet

- (void)showInView:(UIView *)view;
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
- (void)showFromToolbar:(UIToolbar *)toolbar;
- (void)showFromTabBar:(UITabBar *)tabbar;

>>>>>>> devel

/// @name Properties and destroy

/// Count the buttons.
- (NSUInteger)buttonCount;

/// Clears all blocks, breaks retain cycles. Automatically called once a button has been pressed.
- (void)destroy;

/// Call block when actionsheet gets dismissed.
- (void)setDestroyBlock:(void (^)())block;
<<<<<<< HEAD
=======

/// Internal actionSheet.
@property (nonatomic, strong, readonly) UIActionSheet *actionSheet;

// Delegate. weak reference, relays events
@property (nonatomic, assign) id<UIActionSheetDelegate> delegate;
>>>>>>> devel

@end
