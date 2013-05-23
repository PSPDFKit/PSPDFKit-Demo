//
//  PSPDFMenuItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>

/**
 This subclass adds support for a block-based action on UIMenuItem.
 If you are as annoyed about the missing target/action pattern, you will love this.

 If you use PSPDFMenuItem with the classic initWithTitle:selector initializer,
 this will work and be handled just like a UIMenuItem.

 @warning By design, PSPDFMenuItem will only work with *different* title names. Title is required to be > 0 and unique, even when images are used.
 */
@interface PSPDFMenuItem : UIMenuItem

/// Initialize PSPDFMenuItem with a block.
- (id)initWithTitle:(NSString *)title block:(void (^)())block;

/// Initialize PSPDFMenuItem with a block and an unlocalized identifier for later manipulation.
- (id)initWithTitle:(NSString *)title block:(void (^)())block identifier:(NSString *)identifier;

/// Initialize PSPDFMenuItem with an image, a block and an unlocalized identifier for later manipulation.
/// Will not allow image colors.
- (id)initWithTitle:(NSString *)title image:(UIImage *)image block:(void (^)())block identifier:(NSString *)identifier;

/// Initialize PSPDFMenuItem with an image, a block and an unlocalized identifier for later manipulation.
- (id)initWithTitle:(NSString *)title image:(UIImage *)image block:(void (^)())block identifier:(NSString *)identifier allowImageColors:(BOOL)allowImageColors;

/// Menu item can be enabled/disabled. (disable simply hides it from the UIMenuController)
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

/// Helper to identify the current action.
@property (nonatomic, copy) NSString *identifier;

/// Title of the menu item.
@property (nonatomic, copy) NSString *title;

/// Image of the menu item.
///
/// If set, will hide the title.
/// This is prefixed to make sure it will work even when Apple decides to add support for images in future releases.
/// @warning Due to implementation details, this will actually change 'title'. Use identifier to compare menuItems instead.
@property (nonatomic, copy) UIImage *ps_image;

// Action block.
@property (nonatomic, copy) void(^actionBlock)();


/**
 Installs the menu handler. Needs to be called once per class.
 (A good place is the +load method)

 Following methods will be swizzled:
 - canBecomeFirstResponder (if object doesn't already return YES)
 - canPerformAction:withSender:
 - methodSignatureForSelector:
 - forwardInvocation:

 The original implementation will be called if the PSPDFMenuItem selector is not detected.

 @param object can be an instance or a class.
 */
+ (void)installMenuHandlerForObject:(id)object;

@end

// PSPDFMenuItem also adds support for images. This doesn't use private API but requires some method swizzling.
// Disable the image feature by setting this variable to NO before you set any image (e.g. in your AppDelegate)
// Defaults to YES.
extern BOOL kPSPDFAllowImagesForMenuItems;
