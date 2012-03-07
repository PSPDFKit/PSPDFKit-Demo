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
@interface PSPDFActionSheet : NSObject

/// Default initializer.
- (id)initWithTitle:(NSString *)title;

/// Adds a cancel button. Use only once.
- (void)setCancelButtonWithTitle:(NSString *) title block:(void (^)()) block;

/// Adds a destructive button. Use only once.
- (void)setDestructiveButtonWithTitle:(NSString *) title block:(void (^)()) block;

/// Add regular button.
- (void)addButtonWithTitle:(NSString *) title block:(void (^)()) block;

/// Show ActionSheet.
- (void)showInView:(UIView *)view;
- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated;
- (void)showFromRect:(CGRect)rect inView:(UIView *)view animated:(BOOL)animated;
- (void)showFromToolbar:(UIToolbar *)toolbar;
- (void)showFromTabBar:(UITabBar *)tabbar;

/// Count the buttons.
- (NSUInteger)buttonCount;

/// Clears all blocks, breaks reatain cycle. Automatically called once a button has been pressed.
- (void)destroy;

/// Internal actionSheet.
@property (nonatomic, retain, readonly) UIActionSheet *actionSheet;

// Delegate. weak reference, relays events
@property (nonatomic, assign) id<UIActionSheetDelegate> delegate;

@end
