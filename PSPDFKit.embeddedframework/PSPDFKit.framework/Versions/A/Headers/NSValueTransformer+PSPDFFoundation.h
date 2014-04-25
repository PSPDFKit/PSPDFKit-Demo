//
//  NSValueTransformer+PSPDFFoundation.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//
//  Based on GitHub's Mantle project, MIT licensed.
//

#import <Foundation/Foundation.h>

// The name for a value transformer that converts strings into URLs and back.
extern NSString * const PSPDFURLValueTransformerName;

// The name for a value transformer that converts `NSDate` to an ISO8601 date string and back.
extern NSString * const PSPDFISO8601DateValueTransformerName;

// Converts a `CGRect` into `NSString`, reversible.
extern NSString * const PSPDFRectValueTransformerName;

// Converts an array of `CGRect`s into an array of `NSString`s, reversible.
extern NSString * const PSPDFRectArrayValueTransformerName;

// Converts an array of `CGPoint` objects into an `NSString`, reversible.
extern NSString * const PSPDFPointArrayValueTransformerName;

// Converts a arrays of arrays of `CGPoint` objects into an array of array of `NSString`s, reversible.
extern NSString * const PSPDFLinesValueTransformerName;

// Converts a `CGAffineTransform` into `NSString` and back.
extern NSString * const PSPDFAffineTransformValueTransformerName;

// Ensure an NSNumber is backed by __NSCFBoolean/CFBooleanRef
//
// NSJSONSerialization, and likely other serialization libraries, ordinarily
// serialize NSNumbers as numbers, and thus booleans would be serialized as
// 0/1. The exception is when the NSNumber is backed by __NSCFBoolean, which,
// though very much an implementation detail, is detected and serialized as a
// proper boolean.
extern NSString * const PSPDFBooleanValueTransformerName;

@interface NSValueTransformer (PSPDFFoundation)

// Creates a reversible transformer to convert a JSON dictionary into a PSPDFModel
// object, and vice-versa.
//
// modelClass - The `PSPDFModel` subclass to attempt to parse from the JSON. This
//              class must conform to `<PSPDFJSONSerializing>`. This argument must
//              not be nil.
//
// Returns a reversible transformer which uses `PSPDFJSONAdapter` for transforming
// values back and forth.
+ (NSValueTransformer *)pspdf_JSONDictionaryTransformerWithModelClass:(Class)modelClass;

// Creates a reversible transformer to convert an array of JSON dictionaries
// into an array of `PSPDFModel` objects, and vice-versa.
//
// modelClass - The `PSPDFModel` subclass to attempt to parse from each JSON
//              dictionary. This class must conform to `<PSPDFJSONSerializing>`.
//              This argument must not be nil.
//
// Returns a reversible transformer which uses `PSPDFJSONAdapter` for transforming
// array elements back and forth.
+ (NSValueTransformer *)pspdf_JSONArrayTransformerWithModelClass:(Class)modelClass;

@end
