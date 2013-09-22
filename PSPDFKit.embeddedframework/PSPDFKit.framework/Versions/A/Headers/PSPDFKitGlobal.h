//
//  PSPDFKitGlobal.h
//  PSPDFKit
//
//  Copyright 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFLocalization.h"
#import "PSPDFOverridable.h"
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

// Version detection
#define __PSPDFKIT_IOS__
#define __PSPDFKIT_3_0_0 3000
extern NSString *PSPDFVersionString(void); // Returns "PSPDFKit 3.x.x"
extern NSDate   *PSPDFVersionDate(void);   // Returns date of compilation.

typedef NS_ENUM(NSInteger, PSPDFLogLevelMask) {
    PSPDFLogLevelMaskNothing  = 0,
    PSPDFLogLevelMaskError    = 1 << 0,
    PSPDFLogLevelMaskWarning  = 1 << 1,
    PSPDFLogLevelMaskInfo     = 1 << 2,
    PSPDFLogLevelMaskVerbose  = 1 << 3,
    PSPDFLogLevelMaskAll      = INT_MAX
};

/// Set the global PSPDFKit log level. Defaults to PSPDFLogLevelMaskError|PSPDFLogLevelMaskWarning.
/// @warning Setting this to Verbose will severely slow down your application.
extern PSPDFLogLevelMask PSPDFLogLevel;

/// Settings for various animations in PSPDFKit.
typedef NS_ENUM(NSInteger, PSPDFAnimate) {
    PSPDFAnimateNever,
    PSPDFAnimateModernDevices,
    PSPDFAnimateEverywhere
};
extern PSPDFAnimate PSPDFAnimateOption; /// defaults to PSPDFAnimateModernDevices.

/// Enable to use less memory. Some operations might need more time to complete, and caching will be less efficient. Defaults to NO.
/// @note This might be useful if your own app needs a lot of memory or you're seeing memory related crashes with complex PDFs.
extern BOOL PSPDFLowMemoryMode;

/// Improves scroll performance.
extern CGFloat PSPDFInitialAnnotationLoadDelay;

// Compares sizes and allows aspect ratio changes.
extern BOOL PSPDFSizeAspectRatioEqualToSize(CGSize containerSize, CGSize size);

// Trims down a string, removing characters like \n 's etc.
extern NSString *PSPDFTrimString(NSString *string);

// Convert an NSArray of NSNumber's to an NSIndexSet
extern NSIndexSet *PSPDFIndexSetFromArray(NSArray *array);

// Checks if controller is `controllerClass` or inside a UINavigationController/UIPopoverController
extern BOOL PSPDFIsControllerClassAndVisible(id controller, Class controllerClass);

// Global rotation lock/unlock for the whole app. Acts as a counter, can be called multiple times.
// This is iOS6+ only, and only if compiled with the iOS 6 SDK (Since Apple drastically changed the way rotation works)
// Older variants still need shouldAutorotate* handling in the view controllers.
extern void PSPDFLockRotation(void);
extern void PSPDFUnlockRotation(void);

// Returns whether both objects are identical or equal via -isEqual.
extern BOOL PSPDFEqualObjects(id obj1, id obj2);

/// Convert a view point to a pdf point. bounds is from the view (usually PSPDFPageView.bounds)
extern CGPoint PSPDFConvertViewPointToPDFPoint(CGPoint viewPoint, CGRect cropBox, NSUInteger rotation, CGRect bounds);
/// Convert a pdf point to a view point.
extern CGPoint PSPDFConvertPDFPointToViewPoint(CGPoint pdfPoint, CGRect cropBox, NSUInteger rotation, CGRect bounds);
/// Convert a pdf rect to a normalized view rect.
extern CGRect PSPDFConvertPDFRectToViewRect(CGRect pdfRect, CGRect cropBox, NSUInteger rotation, CGRect bounds);
/// Convert a view rect to a normalized pdf rect
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

// Defines a yet undocumented compiler attribute to add a warning if super isn't called.
#ifndef NS_REQUIRES_SUPER
#if __has_attribute(objc_requires_super)
#define NS_REQUIRES_SUPER __attribute((objc_requires_super))
#else
#define NS_REQUIRES_SUPER
#endif
#endif

// Starting with iOS6, dispatch queue's can be objects and managed via ARC.
#if OS_OBJECT_USE_OBJC
#define PSPDFDispatchRelease(queue)
#else
#define PSPDFDispatchRelease(queue) do { if (queue) dispatch_release(queue); }while(0)
#endif
