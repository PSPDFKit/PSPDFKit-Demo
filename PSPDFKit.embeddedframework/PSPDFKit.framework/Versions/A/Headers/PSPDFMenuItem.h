//
//  PSPDFMenuItem.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This subclass adds support for a block-based action on UIMenuItem.
 If you are as annoyed about the missing target/action pattern, you will love this.

 Note: This has one flaw, it doesn't work if the titles are equal within UIMenuController.

 If you use PSPDFMenuItem with the classic initWithTitle:selector initializer,
 this will work and be handled just like a UIMenuItem.
 */
@interface PSPDFMenuItem : UIMenuItem

/// Initialize PSPDFMenuItem with a block.
- (id)initWithTitle:(NSString *)title block:(void(^)())block;

- (id)initWithTitle:(NSString *)title block:(void(^)())block identifier:(NSString *)identifier;

/// Menu Item can be enabled/disabled. (disable simply hides it from the UIMenuController)
@property(nonatomic, assign, getter=isEnabled) BOOL enabled;

/// Helper to identify the current action.
@property(nonatomic, copy) NSString *identifier;

// Action block.
@property(nonatomic, copy) void(^block)();


/**
 Installs the menu handler. Needs to be called once per class.
 (A good place is the +load method)

 Following methods will be swizzled:
 - canBecomeFirstResponder (if object doesn't already return YES)
 - canPerformAction:withSender:
 - methodSignatureForSelector:
 - forwardInvocation:

 The original implementation will be called if the PSPDFMenuItem selector is not detected.

 @parm object can be an instance or a class.
 */
+ (void)installMenuHandlerForObject:(id)object;

@end
