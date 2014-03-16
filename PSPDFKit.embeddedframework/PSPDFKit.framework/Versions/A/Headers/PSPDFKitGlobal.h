//
//  PSPDFKitGlobal.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFLocalization.h"
#import "PSPDFOverridable.h"
@import Foundation;
@import CoreGraphics;
@import UIKit;

// PSPDFKit version detection.
#define __PSPDFKIT_IOS__
#define __PSPDFKIT_3_0_0 3000
#define __PSPDFKIT_3_1_0 3100
#define __PSPDFKIT_3_2_0 3200
#define __PSPDFKIT_3_3_0 3300
#define __PSPDFKIT_3_4_0 3400
#define __PSPDFKIT_3_5_0 3500
#define __PSPDFKIT_3_6_0 3600

extern NSString *PSPDFVersionString(void); // Returns "PSPDFKit 3.x.x"
extern NSDate   *PSPDFVersionDate(void);   // Returns compilation date.

typedef NS_ENUM(NSUInteger, PSPDFLogLevelMask) {
    PSPDFLogLevelMaskNothing  = 0,
    PSPDFLogLevelMaskError    = 1 << 0,
    PSPDFLogLevelMaskWarning  = 1 << 1,
    PSPDFLogLevelMaskInfo     = 1 << 2,
    PSPDFLogLevelMaskVerbose  = 1 << 3,
    PSPDFLogLevelMaskAll      = UINT_MAX
};

/// Set the global PSPDFKit log level. Defaults to `PSPDFLogLevelMaskError|PSPDFLogLevelMaskWarning`.
/// @warning Setting this to Verbose will severely slow down your application.
extern PSPDFLogLevelMask PSPDFLogLevel;

/// Settings for various animations in PSPDFKit.
typedef NS_ENUM(NSInteger, PSPDFAnimate) {
    PSPDFAnimateNever,
    PSPDFAnimateModernDevices,
    PSPDFAnimateEverywhere     // Will also animate page changes.
};
extern PSPDFAnimate PSPDFAnimateOption; /// defaults to `PSPDFAnimateModernDevices`.

/// Enable to use less memory. Some operations might need more time to complete, and caching will be less efficient. Defaults to NO.
/// @note This might be useful if your own app needs a lot of memory or you're seeing memory related crashes with complex PDFs.
extern BOOL PSPDFLowMemoryMode;

/// Callback URL to allow a back-button. Currently only used for the Open In Chrome feature.
/// See https://developers.google.com/chrome/mobile/docs/ios-links
extern void PSPDFSetXCallbackString(NSString *callbackString);

// Compares sizes and allows aspect ratio changes.
extern BOOL PSPDFSizeAspectRatioEqualToSize(CGSize containerSize, CGSize size);

// Convert an `NSArray` of `NSNumber's` to an `NSIndexSet`.
extern NSIndexSet *PSPDFIndexSetFromArray(NSArray *array);

// Global rotation lock/unlock for the whole app. Acts as a counter, can be called multiple times.
extern void PSPDFLockRotation(BOOL enableLock);

// Returns whether both objects are identical or equal via `isEqual:`.
extern BOOL PSPDFEqualObjects(id obj1, id obj2);

/// Convert a view point to a pdf point. `bounds` is from the view. (usually `PSPDFPageView.bounds`)
extern CGPoint PSPDFConvertViewPointToPDFPoint(CGPoint viewPoint, CGRect cropBox, NSUInteger rotation, CGRect bounds);
/// Convert a pdf point to a view point.
extern CGPoint PSPDFConvertPDFPointToViewPoint(CGPoint pdfPoint, CGRect cropBox, NSUInteger rotation, CGRect bounds);
/// Convert a pdf rect to a normalized view rect.
extern CGRect PSPDFConvertPDFRectToViewRect(CGRect pdfRect, CGRect cropBox, NSUInteger rotation, CGRect bounds);
/// Convert a view rect to a normalized pdf rect.
extern CGRect PSPDFConvertViewRectToPDFRect(CGRect viewRect, CGRect cropBox, NSUInteger rotation, CGRect bounds);

#define BOXED(val) ({ typeof(val) _tmp_val = (val); [NSValue valueWithBytes:&(_tmp_val) objCType:@encode(typeof(val))]; })

// Compiler-checked selectors and performance optimized at runtime.
#if DEBUG
#define PSPDF_KEYPATH(object, property) ((void)(NO && ((void)object.property, NO)), @#property)
#define PSPDF_KEYPATH_SELF(property) PSPDF_KEYPATH(self, property)
#define PROPERTY(property) NSStringFromSelector(@selector(property))
// Useful to look up a key with just a class object
#define PSPDFKeyForClass(CLASS, KEY) ((void)(NO && ^(CLASS *obj){ (void)obj.KEY; }), @#KEY )
#else
#define PROPERTY(property) @#property
#define PSPDF_KEYPATH(object, property) @#property
#define PSPDF_KEYPATH_SELF(property) PSPDF_KEYPATH(self, property)
#define PSPDFKeyForClass(CLASS, KEY) @#KEY
#endif

#ifndef NS_DESIGNATED_INITIALIZER
#if __has_attribute(objc_designated_initializer)
#define NS_DESIGNATED_INITIALIZER __attribute((objc_designated_initializer))
#else
#define NS_DESIGNATED_INITIALIZER
#endif
#endif

// PSPDFKit deprecation helper.
#define PSPDF_DEPRECATED(version, msg) __attribute__((deprecated("Deprecated in PSPDFKit " #version ". " msg)))
