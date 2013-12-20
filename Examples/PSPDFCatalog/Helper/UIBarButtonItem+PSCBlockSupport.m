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

const char PSCBlockSupportKey;

@interface NSObject (PSCBlockSupport)
- (void)psc_callbackBlockWithSender:(id)sender;
@end

@implementation NSObject (PSCBlockSupport)
- (void)psc_callbackBlockWithSender:(id)sender { ((void (^)(id))self)(sender); }
@end

@implementation UIBarButtonItem (PSCBlockSupport)

- (id)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style block:(void (^)(id))block {
    // Call correct initializer. Provide the block callback as action, but no target yet
    if ((self = [self initWithTitle:title style:style target:nil action:@selector(psc_callbackBlockWithSender:)])) {
        objc_setAssociatedObject(self, &PSCBlockSupportKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
        self.target = objc_getAssociatedObject(self, &PSCBlockSupportKey);
    }
    return self;
}

@end
