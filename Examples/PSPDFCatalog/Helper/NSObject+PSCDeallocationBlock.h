//
//  NSObject+PSCDeallocationBlock.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@interface NSObject (PSCDeallocationBlock)

// Register block to be called when `self` is deallocated.
- (void)psc_addDeallocBlock:(void (^)(void))block;

@end
