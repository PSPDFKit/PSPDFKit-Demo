//
//  PSCExampleManager.h
//  PSPDFCatalog
//
//  Copyright (c) 2012-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSCExample.h"

// Manages all examples (all subclasses of `PSCExample`).
@interface PSCExampleManager : NSObject

// Singleton
+ (instancetype)defaultManager;

// Get all examples.
@property (nonatomic, copy, readonly) NSArray *allExamples;

@end
