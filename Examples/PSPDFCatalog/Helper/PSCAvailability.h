//
//  PSCAvailability.h
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

// Logging
#define kPSCLogEnabled
#ifdef kPSCLogEnabled
#define PSCLog(fmt, ...) NSLog((@"%s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define PSCLog(...)
#endif

// iOS7 compatibility
#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.2
#endif

// Availability Macros
#define PSIsIpad() (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#define PSC_IF_IOS7_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) { __VA_ARGS__ }
#else
#define PSC_IF_IOS7_OR_GREATER(...)
#endif

#define PSC_IF_PRE_IOS7(...)  \
if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_7_0 || __IPHONE_OS_VERSION_MAX_ALLOWED < 70000) { __VA_ARGS__ }
