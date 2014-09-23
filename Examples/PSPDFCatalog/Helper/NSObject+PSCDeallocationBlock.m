//
//  NSObject+PSCDeallocationBlock.m
//  PSPDFCatalog
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "NSObject+PSCDeallocationBlock.h"
#import <objc/runtime.h>

@interface PSCBlockWrapper : NSObject
@property (nonatomic, copy) dispatch_block_t block;
@end
@implementation PSCBlockWrapper
- (void)dealloc { if (_block) _block(); }
@end

@implementation NSObject (PSCDeallocationBlock)

static const char PSCDeallocationKey;
- (void)psc_addDeallocBlock:(void (^)(void))block {
    @synchronized(self) {
        // Get current block array and add one element.
        NSArray *blocks = objc_getAssociatedObject(self, &PSCDeallocationKey);
        PSCBlockWrapper *blockWrapper = [[PSCBlockWrapper alloc] init];
        blockWrapper.block = block;
        blocks = [blocks ?: @[] arrayByAddingObject:blockWrapper];
        objc_setAssociatedObject(self, &PSCDeallocationKey, blocks, OBJC_ASSOCIATION_COPY);
    }
}

@end
