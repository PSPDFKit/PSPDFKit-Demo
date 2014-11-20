//
//  NSArray+PSCIndexSet.h
//  PSPDFCatalog
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

@interface NSArray (PSCIndexSet)

// Convert an `NSArray` of `NSNumber's` to an `NSIndexSet`.
- (NSIndexSet *)psc_indexSet;

@end
