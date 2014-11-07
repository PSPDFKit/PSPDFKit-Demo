//
//  PSCAlertView.m
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//
//

#import "PSCAlertView.h"
#import <objc/runtime.h>

@interface PSCAlertView () <UIAlertViewDelegate>
@property (nonatomic, assign, getter=isDismissing) BOOL dismissing;
@property (nonatomic, copy) NSArray *blocks;
@property (nonatomic, copy) NSArray *willDismissBlocks;
@property (nonatomic, copy) NSArray *didDismissBlocks;
@property (nonatomic, weak) id<UIAlertViewDelegate> realDelegate;
@end

static NSUInteger PSPDFVisibleAlertsCount = 0;

@implementation PSCAlertView

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
    if ((self = [self initWithTitle:title message:nil])) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    if ((self = [super initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil])) {
        [self commonInit];
    }
    return self;
}

// Can be called multiple times on iOS < 8.
- (void)commonInit {
    [super setDelegate:self];
}

- (void)dealloc {
    self.delegate = nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p numberOfButtons:%zd title:%@>", NSStringFromClass(self.class), self, self.numberOfButtons, self.title];
}

- (void)destroy {
    self.blocks = nil;
    self.willDismissBlocks = nil;
    self.didDismissBlocks = nil;
    self.delegate = nil;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)setDelegate:(id/**<UIAlertViewDelegate>*/)delegate {
    [super setDelegate:delegate ? self : nil];
    self.realDelegate = delegate != self ? delegate : nil;
}

- (NSInteger)setCancelButtonWithTitle:(NSString *)title block:(void (^)(NSInteger buttonIndex))block {
    NSUInteger buttonIndex = [self addButtonWithTitle:title block:block];
    self.cancelButtonIndex = buttonIndex;
    return buttonIndex;
}

- (NSInteger)addButtonWithTitle:(NSString *)title block:(void (^)(NSInteger buttonIndex))block {
    NSParameterAssert(title);
    self.blocks = [[NSArray arrayWithArray:self.blocks] arrayByAddingObject:[block copy] ?: NSNull.null];
    return [self addButtonWithTitle:title];
}

- (NSInteger)addButtonWithTitle:(NSString *)title {
    NSInteger buttonIndex = [super addButtonWithTitle:title];

    // Ensure blocks array is equal to number of buttons.
    while (self.blocks.count < (NSUInteger)self.numberOfButtons) {
        self.blocks = [[NSArray arrayWithArray:self.blocks] arrayByAddingObject:NSNull.null];
    }

    return buttonIndex;
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    [super dismissWithClickedButtonIndex:buttonIndex animated:animated];

    // In iOS 8, this method is being called even when we dismissed based on a button action.
    // It's not called on iOS 7 or earlier. We track if it's a user-initiated or programmatic
    // dismissal via `isDismissing`.
    if (!self.isDismissing) {
        [self alertView:self clickedButtonAtIndex:buttonIndex];
    }
}

- (void)addWillDismissBlock:(void (^)(NSInteger buttonIndex))willDismissBlock {
    NSParameterAssert(willDismissBlock);
    self.willDismissBlocks = [[NSArray arrayWithArray:self.willDismissBlocks] arrayByAddingObject:willDismissBlock];
}

- (void)addDidDismissBlock:(void (^)(NSInteger buttonIndex))didDismissBlock {
    NSParameterAssert(didDismissBlock);
    self.didDismissBlocks = [[NSArray arrayWithArray:self.didDismissBlocks] arrayByAddingObject:didDismissBlock];
}

- (void)_callBlocks:(NSArray *)blocks withButtonIndex:(NSInteger)buttonIndex {
    for (void (^block)(NSInteger buttonIndex) in blocks) {
        block(buttonIndex);
    }
}

+ (BOOL)areAnyPSPDFAlertsVisible {
    return PSPDFVisibleAlertsCount > 0;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // Run the button's block.
    if (buttonIndex >= 0 && buttonIndex < (NSInteger)self.blocks.count) {
        void (^block)(NSUInteger) = self.blocks[buttonIndex];
        if (![block isEqual:NSNull.null]) {
            block(buttonIndex);
        }
    }

    id<UIAlertViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate alertView:alertView clickedButtonAtIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.dismissing = YES;
    PSPDFVisibleAlertsCount--;

    [self _callBlocks:self.willDismissBlocks withButtonIndex:buttonIndex];

    id<UIAlertViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate alertView:alertView willDismissWithButtonIndex:buttonIndex];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [self _callBlocks:self.didDismissBlocks withButtonIndex:buttonIndex];

    id<UIAlertViewDelegate> delegate = self.realDelegate;
    if ([delegate respondsToSelector:_cmd]) {
        [delegate alertView:alertView didDismissWithButtonIndex:buttonIndex];
    }

    [self destroy];
    self.dismissing = NO;
}

- (void)show {
    PSPDFVisibleAlertsCount++;
    [super show];
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
