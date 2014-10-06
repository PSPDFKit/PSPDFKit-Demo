//
//  PSCAvailability.h
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

#define BOXED(val) ({ typeof(val) _tmp_val = (val); [NSValue valueWithBytes:&(_tmp_val) objCType:@encode(typeof(val))]; })

// Compiler-checked selectors and performance optimized at runtime.
#ifdef DEBUG
#define PROPERTY(property) NSStringFromSelector(@selector(property))
#else
#define PROPERTY(property) @#property
#endif

// Logging
#define kPSCLogEnabled
#ifdef kPSCLogEnabled
#define PSCLog(fmt, ...) NSLog((@"%s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define PSCLog(...)
#endif

// iOS 8 Compatibility
#ifndef kCFCoreFoundationVersionNumber_iOS_8_0
#define kCFCoreFoundationVersionNumber_iOS_8_0 1129.15
#endif

// Availability Macros
#define PSCIsIPad() (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
#define PSC_IF_IOS8_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0) { __VA_ARGS__ }
#else
#define PSC_IF_IOS8_OR_GREATER(...)
#endif

#define PSC_IF_PRE_IOS8(...)  \
if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_8_0 || __IPHONE_OS_VERSION_MAX_ALLOWED < 80000) { __VA_ARGS__ }
