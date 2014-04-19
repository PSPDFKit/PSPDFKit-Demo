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
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

// PSPDFKit compile time version detection.
#define __PSPDFKIT_IOS__
#define __PSPDFKIT_3_0_0 3000
#define __PSPDFKIT_3_1_0 3100
#define __PSPDFKIT_3_2_0 3200
#define __PSPDFKIT_3_3_0 3300
#define __PSPDFKIT_3_4_0 3400
#define __PSPDFKIT_3_5_0 3500
#define __PSPDFKIT_3_6_0 3600
#define __PSPDFKIT_3_7_0 3700

extern NSString *PSPDFVersionString(void); // Returns "PSPDFKit 3.x.x"
extern NSDate   *PSPDFVersionDate(void);   // Returns compilation date.

/// Settings for various animations in PSPDFKit.
typedef NS_ENUM(NSInteger, PSPDFAnimate) {
    PSPDFAnimateNever,
    PSPDFAnimateModernDevices,
    PSPDFAnimateEverywhere     // Will also animate page changes.
};
extern PSPDFAnimate PSPDFAnimateOption; /// defaults to `PSPDFAnimateModernDevices`.

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

#ifndef NS_DESIGNATED_INITIALIZER
#if __has_attribute(objc_designated_initializer)
#define NS_DESIGNATED_INITIALIZER __attribute((objc_designated_initializer))
#else
#define NS_DESIGNATED_INITIALIZER
#endif
#endif

// PSPDFKit deprecation helper.
#define PSPDF_DEPRECATED(version, msg) __attribute__((deprecated("Deprecated in PSPDFKit " #version ". " msg)))
