//
//  PSPDFConverter.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFStream;

/// Get string from CGPDFDictionary.
extern inline NSString *PSPDFDictionaryGetString(CGPDFDictionaryRef pdfDict, NSString *key);

extern inline NSString *PSPDFDictionaryGetStringC(CGPDFDictionaryRef pdfDict, const char *key);

/// Get string from CGPDFArray.
extern inline NSString *PSPDFArrayGetString(CGPDFArrayRef pdfArray, size_t index);

/// Get the PDF object at the specific PDF path. Can access arrays or streams with #0 syntax.
extern id PSPDFDictionaryGetObjectForPath(CGPDFDictionaryRef pdfDict, NSString *keyPath);

/// Get the PDF date (converted from string/name)
extern NSDate *PSPDFDictionaryGetDateC(CGPDFDictionaryRef pdfDict, const char *key);

/// Like PSPDFDictionaryGetObjectForPath, but type safe.
id PSPDFDictionaryGetObjectForPathOfType(CGPDFDictionaryRef pdfDict, NSString *keyPath, Class returnClass);

extern PSPDFStream *PSPDFDictionaryGetStreamForPath(CGPDFDictionaryRef pdfDict, NSString *keyPath);

extern NSNumber *PSPDFDictionaryGetNumberC(CGPDFDictionaryRef pdfDict, const char *key);

extern NSUInteger PSPDFDictionaryGetIntegerC(CGPDFDictionaryRef pdfDict, const char *key);

extern NSString *PSPDFDictionaryGetStringForPath(CGPDFDictionaryRef pdfDict, NSString *keyPath);

extern NSArray *PSPDFDictionaryGetArrayForPath(CGPDFDictionaryRef pdfDict, NSString *keyPath);

extern NSDictionary *PSPDFDictionaryGetDictionaryForPath(CGPDFDictionaryRef pdfDict, NSString *keyPath);

/// Convert a single PDF object to the corresponding CoreFoundation-object.
extern id PSPDFConvertPDFObject(CGPDFObjectRef objectRef);

/// Convert a PDF object but only if it can be converted to a string.
extern NSString *PSPDFConvertPDFObjectAsString(CGPDFObjectRef objectRef);

/// Converts a CGPDFDictionary into an NSDictionary.
extern NSDictionary *PSPDFConvertPDFDictionary(CGPDFDictionaryRef pdfDict);

/// Converts a CGPDFArray into an NSArray.
extern NSArray *PSPDFConvertPDFArray(CGPDFArrayRef pdfArray);
