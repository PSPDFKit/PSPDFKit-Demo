//
//  PSPDFActionSheet.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Helper to add block features to UIActionSheet.
/// After block has been executed, it is set to nil, breaking potential retain cycles.
@interface PSPDFActionSheet : UIActionSheet

/// @name Initialization

/// Default initializer.
- (id)initWithTitle:(NSString *)title;

/// @name Adding Buttons

/// Adds a cancel button. Use only once.
- (void)setCancelButtonWithTitle:(NSString *) title block:(void (^)())block;
- (void)setCancelButtonWithTitle:(NSString *) title extendedBlock:(void (^)(PSPDFActionSheet *sheet, NSInteger buttonIndex))block;

/// Adds a destructive button. Use only once.
- (void)setDestructiveButtonWithTitle:(NSString *) title block:(void (^)())block;
- (void)setDestructiveButtonWithTitle:(NSString *) title extendedBlock:(void (^)(PSPDFActionSheet *sheet, NSInteger buttonIndex))block;

/// Add regular button.
- (void)addButtonWithTitle:(NSString *) title block:(void (^)())block;
- (void)addButtonWithTitle:(NSString *) title extendedBlock:(void (^)(PSPDFActionSheet *sheet, NSInteger buttonIndex))block;

/// @name Properties and show/destroy

/// Count the buttons.
- (NSUInteger)buttonCount;

/// Is clever about the sender, uses fallbackView if sender is not usable (nil, or not UIBarButtonItem/UIView)
- (void)showWithSender:(id)sender fallbackView:(UIView *)view animated:(BOOL)animated;

/// Clears all blocks, breaks retain cycles. Automatically called once a button has been pressed.
- (void)destroy;

/// Call block when action sheet gets dismissed.
@property (nonatomic, copy) void (^destroyBlock)(PSPDFActionSheet *sheet, NSInteger buttonIndex);

@end
