//
//  UIBarButtonItem+PSCBlockSupport.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "UIBarButtonItem+PSCBlockSupport.h"
#import <objc/runtime.h>

static const char PSCBlockSupportKey;

@interface NSObject (PSCBlockSupport)
- (void)psc_callbackBlockWithSender:(id)sender;
@end

@implementation NSObject (PSCBlockSupport)
- (void)psc_callbackBlockWithSender:(id)sender { ((void (^)(id))self)(sender); }
@end

@implementation UIBarButtonItem (PSCBlockSupport)

- (instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style block:(void (^)(id sender))block {
    // Call correct initializer. Provide the block callback as action, but no target yet
    if ((self = [self initWithTitle:title style:style target:nil action:@selector(psc_callbackBlockWithSender:)])) {
        objc_setAssociatedObject(self, &PSCBlockSupportKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        self.target = objc_getAssociatedObject(self, &PSCBlockSupportKey);
    }
    return self;
}

@end

#define PSPDF_SILENCE_CALL_TO_UNKNOWN_SELECTOR(expression) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
expression \
_Pragma("clang diagnostic pop")

#define PSPDFWeakifyAs(object, weakName) typeof(object) __weak weakName = object

void (^PSCTargetActionBlock(id target, SEL action))(id) {
    // All ObjC methods have two arguments. This fails if either target is nil, action not implemented or else.
    NSUInteger numberOfArguments = [target methodSignatureForSelector:action].numberOfArguments;
    NSCAssert(numberOfArguments == 2 || numberOfArguments == 3, @"%@ should have at most one argument.", NSStringFromSelector(action));

    PSPDFWeakifyAs(target, weakTarget);
    if (numberOfArguments == 2) {
        return ^(__unused id sender) { PSPDF_SILENCE_CALL_TO_UNKNOWN_SELECTOR([weakTarget performSelector:action];) };
    } else {
        return ^(id sender) { PSPDF_SILENCE_CALL_TO_UNKNOWN_SELECTOR([weakTarget performSelector:action withObject:sender];) };
    }
}