//
//  NSArray+PSCHelper.m
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "NSArray+PSCHelper.h"

@implementation NSArray (PSCHelper)

- (NSIndexSet *)psc_indexSet {
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    for (NSNumber *number in self) {
        [indexSet addIndex:[number unsignedIntegerValue]];
    }
    return [indexSet copy];
}

@end
