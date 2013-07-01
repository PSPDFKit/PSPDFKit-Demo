//
//  PSCAvailability.h
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>

// Logging
#define kPSCLogEnabled
#ifdef kPSCLogEnabled
#define PSCLog(fmt, ...) NSLog((@"%s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);;
#else
#define PSCLog(...)
#endif

// iOS6 compatibility
#ifndef kCFCoreFoundationVersionNumber_iOS_6_0
#define kCFCoreFoundationVersionNumber_iOS_6_0 788.0
#endif

// iOS7 compatibility [BETA 1]
#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 838.0
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
