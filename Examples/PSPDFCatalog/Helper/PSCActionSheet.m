//
//  PSCActionSheet.m
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSCActionSheet.h"
#import <objc/runtime.h>

@interface PSCActionSheet () <UIActionSheetDelegate>
@property (nonatomic, assign, getter=isDismissing) BOOL dismissing;
@property (nonatomic, copy) NSArray *blocks;
@property (nonatomic, copy) NSArray *cancelBlocks;
@property (nonatomic, copy) NSArray *willDismissBlocks;
@property (nonatomic, copy) NSArray *didDismissBlocks;
@property (nonatomic, weak) id<UIActionSheetDelegate> realDelegate;
@end

@implementation PSCActionSheet

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)init {
    if ((self = [super init])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    if ((self = [super initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil])) {
        [self commonInit];
    }
    return self;
}

// Can be called multiple times on iOS < 8.
- (void)commonInit {
    _allowsTapToDismiss = YES;
    [super setDelegate:self];
}

- (void)dealloc {
    self.delegate = nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p numberOfButtons:%zd title:%@>", self.class, self, self.numberOfButtons, self.title];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)setDelegate:(id<UIActionSheetDelegate>)delegate {
    [super setDelegate:delegate ? self : nil];
    self.realDelegate = delegate != self ? delegate : nil;
}

- (void)setDestructiveButtonWithTitle:(NSString *)title block:(void (^)(NSInteger buttonIndex))block {
    [self addButtonWithTitle:title block:block];
    self.destructiveButtonIndex = self.numberOfButtons - 1;
}

- (void)setCancelButtonWithTitle:(NSString *)title block:(void (^)(NSInteger buttonIndex))block {
    [self addButtonWithTitle:title block:block];
    self.cancelButtonIndex = self.numberOfButtons - 1;
}

- (void)addButtonWithTitle:(NSString *)title block:(void (^)(NSInteger buttonIndex))block {
    NSParameterAssert(title);
    self.blocks = [[NSArray arrayWithArray:self.blocks] arrayByAddingObject:[block copy] ?: NSNull.null];
    [self addButtonWithTitle:title];
}

- (NSUInteger)buttonCount {
    return self.blocks.count;
}

- (void)showWithSender:(id)sender fallbackView:(UIView *)view animated:(BOOL)animated {
    BOOL isIPad = UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad;
    if (isIPad && [sender isKindOfClass:UIBarButtonItem.class]) {
        [self showFromBarButtonItem:sender animated:animated];
    } else if ([sender isKindOfClass:UIToolbar.class]) {
        [self showFromToolbar:sender];
    } else if ([sender isKindOfClass:UITabBar.class]) {
        [self showFromTabBar:sender];
    } else if ([view isKindOfClass:UIToolbar.class]) {
        [self showFromToolbar:(UIToolbar *)view];
    } else if ([view isKindOfClass:UITabBar.class]) {
        [self showFromTabBar:(UITabBar *)view];
    } else if (isIPad && [sender isKindOfClass:UIView.class]) {
        [self showFromRect:[sender bounds] inView:sender animated:animated];
    } else if ([sender isKindOfClass:NSValue.class]) {
        [self showFromRect:[sender CGRectValue] inView:view animated:animated];
    } else {
        [self showInView:view];
    }
}

- (void)addCancelBlock:(void (^)(NSInteger buttonIndex))cancelBlock {
    NSParameterAssert(cancelBlock);
    self.cancelBlocks = [[NSArray arrayWithArray:self.cancelBlocks] arrayByAddingObject:cancelBlock];
}

- (void)addWillDismissBlock:(void (^)(NSInteger buttonIndex))willDismissBlock {
    NSParameterAssert(willDismissBlock);
    self.willDismissBlocks = [[NSArray arrayWithArray:self.willDismissBlocks] arrayByAddingObject:willDismissBlock];
}

- (void)addDidDismissBlock:(void (^)(NSInteger buttonIndex))didDismissBlock {
    NSParameterAssert(didDismissBlock);
    self.didDismissBlocks = [[NSArray arrayWithArray:self.didDismissBlocks] arrayByAddingObject:didDismissBlock];
}

- (void)callBlocks:(NSArray *)blocks withButtonIndex:(NSInteger)buttonIndex {
    for (void (^block)(NSInteger buttonIndex) in blocks) {
        block(buttonIndex);
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIActionSheet

- (void)showInView:(UIView *)view {
    if (view.window || [view isKindOfClass:[UIWindow class]]) {
        [super showInView:view];
    } else {
        NSLog(@"Ignoring call since view has no window.");
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns.
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // We want any of the will dismiss blocks to be called before the action blocks.
    [self callBlocks:self.willDismissBlocks withButtonIndex:buttonIndex];
    self.willDismissBlocks = nil;

    // Find the matching action block.`
    if (buttonIndex >= 0 && buttonIndex < (NSInteger)self.blocks.count) {
        void (^block)(NSUInteger) = self.blocks[buttonIndex];
        if (![block isEqual:NSNull.null]) {
            block(buttonIndex);
        }
    }

    // Call cancel blocks. This is -1 if no cancel button is available.
    if (buttonIndex == self.cancelButtonIndex) {
        [self callBlocks:self.cancelBlocks withButtonIndex:buttonIndex];
    }

    // Forward to real delegate.
    id<UIActionSheetDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
    }
}

// Before animation and hiding view.
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    id<UIActionSheetDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate willPresentActionSheet:actionSheet];
    }
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];

    // In iOS 8, this method is being called even when we dismissed based on a button action.
    // It's not called on iOS 7 or earlier. We track if it's a user-initiated or programmatic
    // dismissal via `isDismissingAlertView`.
    if (!self.isDismissing) {
        [self actionSheet:self clickedButtonAtIndex:buttonIndex];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.dismissing = YES;
    [self callBlocks:self.willDismissBlocks withButtonIndex:buttonIndex];
    self.willDismissBlocks = nil;

    id<UIActionSheetDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate actionSheet:actionSheet willDismissWithButtonIndex:buttonIndex];
    }
}

// After animation.
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self callBlocks:self.didDismissBlocks withButtonIndex:buttonIndex];

    id<UIActionSheetDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate actionSheet:actionSheet didDismissWithButtonIndex:buttonIndex];
    }
    self.dismissing = NO;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIPopoverController

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController {
    return self.allowsTapToDismiss;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Delegate Forwarder

- (BOOL)respondsToSelector:(SEL)s {
    return [super respondsToSelector:s] || [self.realDelegate respondsToSelector:s];
}

- (id)forwardingTargetForSelector:(SEL)s {
    id delegate = self.realDelegate;
    return [delegate respondsToSelector:s] ? delegate : [super forwardingTargetForSelector:s];
}

@end
