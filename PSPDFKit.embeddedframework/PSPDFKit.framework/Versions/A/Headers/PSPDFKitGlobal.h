//
//  PSPDFKitGlobal.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@class CATransition;

/// *Completely* disables logging. not advised to change this, use kPSPDFLogLevel instead.
#define kPSPDFKitDebugEnabled

/// If disabled, kPSPDFKitDebugMemory has no effect. Also checks for NS_BLOCK_ASSERTIONS to be NOT set.
#define kPSPDFKitAllowMemoryDebugging

// Newer runtimes defines this, here's a fallback for the iOS5 SDK.
#ifndef NS_ENUM
#define NS_ENUM(_type, _name) _type _name; enum
#define NS_OPTIONS(_type, _name) _type _name; enum
#endif

extern NSString *const kPSPDFErrorDomain;

typedef NS_ENUM(NSInteger, PSPDFErrorCode) {
    PSPDFErrorCodePageInvalid = 100,
    PSPDFErrorCodeUnableToOpenPDF = 200,
    PSPDFErrorCodeDocumentLocked = 300,
    PSPDFErrorCodeFailedToLoadAnnotations = 400,
    PSPDFErrorCodeFailedToWriteAnnotations = 410,
    PSPDFErrorCodeOutlineParser = 500,
    PSPDFErrorCodeUnableToConvertToDataRepresentation = 600,
    PSPDFErrorCodeRemoveCacheError = 700,
    PSPDFErrorCodeUnknown = 900,
};

/// Log level defines.
/// Note that PSPDFLogLevelVerbose will severly slow down the whole application.
/// (e.g. Some lazy evaluated properties will be evaluated on the main thread)
typedef NS_ENUM(NSInteger, PSPDFLogLevel) {
    PSPDFLogLevelNothing = 0,
    PSPDFLogLevelError,
    PSPDFLogLevelWarning,
    PSPDFLogLevelInfo,
    PSPDFLogLevelVerbose
};
extern PSPDFLogLevel kPSPDFLogLevel; // defaults to PSPDFLogLevelWarning

/// Settings for animation of pages, global
typedef NS_ENUM(NSInteger, PSPDFAnimate) {
    PSPDFAnimateNever,
    PSPDFAnimateModernDevices,
    PSPDFAnimateEverywhere
};
extern PSPDFAnimate kPSPDFAnimateOption; /// defaults to PSPDFAnimateModernDevices

/// Default time to animate pdf views. Defaults to 0.1. Only animates from thumbnail to sharp page, and only on modern devices.
extern CGFloat kPSPDFKitPDFAnimationDuration;

/// Evaluates if devices is modern enough to support proper animation (depends on kPSPDFAnimateOption setting)
extern BOOL PSPDFShouldAnimate(void);

/// Optionally enable scrollbar debugging.
extern BOOL kPSPDFDebugScrollViews;

/// Enable to track down memory issues.
extern BOOL kPSPDFKitDebugMemory;

/// Number of open CGPDFDocument's.
extern NSUInteger kPSPDFMaximumNumberOfOpenDocumentRefs;

/// Improves scroll performance.
extern CGFloat kPSPDFInitialAnnotationLoadDelay;

/// Detect if it's a crappy device (everything before iPhone4 or iPad2 is defined as "crap")
extern BOOL PSPDFIsCrappyDevice(void);

/// Class name for PSPDFCache singleton. Change this at the very beginning of your app to support a custom subclass.
extern NSString *kPSPDFCacheClassName;

/// Class name for PSPDFIconGenerator singleton. Change this at the very beginning of your app to support a custom subclass.
extern NSString *kPSPDFIconGeneratorClassName;

/// Get current PSPDFKit version.
extern NSString *PSPDFVersionString(void);

/// Access the PSPDFKit.bundle.
extern NSBundle *PSPDFKitBundle(void);

/// Localizes strings.
extern NSString *PSPDFLocalize(NSString *stringToken);

// Allows to set a custom dictionary that contains dictionaries with language locales.
// Will override localization found in the bundle, if a value is found.
// Falls back to "en" if localization key is not found in dictionary.
extern void PSPDFSetLocalizationDictionary(NSDictionary *localizationDict);

/// Resolves paths like "Documents" or "Bundle" to their real path.
/// If no name is found, the bundle string is always attached, unless fallbackPath is set.
/// resolveUnknownDocumentBlock gets called if a token is found that isn't recognized.
extern NSString *PSPDFResolvePathNames(NSString *path, NSString *fallbackPath);
extern BOOL PSPDFResolvePathNamesInMutableString(NSMutableString *mutableString, NSString *fallbackPath, NSString *(^resolveUnknownPathBlock)(NSString *unknownPath));

/// If you need the 1.9-style path resolving (no marker = bundle path, not pdf path) set this to YES. Defaults to NO.
extern BOOL PSPDFResolvePathNamesEnableLegacyBehavior;

/// Removes the ".pdf" or a cased derivation of it from the fileName, if it exists.
extern NSString *PSPDFStripPDFFileType(NSString *pdfFileName);

/// Queries subviews for a specific class prefix. Usually used for subview-querying.
extern UIView *PSPDFGetViewInsideView(UIView *view, NSString *classNamePrefix);

// Helper for deadlock-free dispatch_sync.
extern inline void pspdf_dispatch_sync_reentrant(dispatch_queue_t queue, dispatch_block_t block);

// Invoke sync or async, depending on condition
extern inline void pspdf_dispatch_async_if(dispatch_queue_t queue, BOOL async, dispatch_block_t block);

// Compensates the effect of SLOW ANIMATIONS in the iOS Simulator.
// Use for CATransition etc. UIKit animations are automatically slowed down.
extern CGFloat PSPDFSimulatorAnimationDragCoefficient(void);

// Creates a default, 0.25sec long fade transition
extern CATransition *PSPDFFadeTransition(void);

// Creates a fade transition with 'duration' timimg.
extern CATransition *PSPDFFadeTransitionWithDuration(CGFloat duration);

// Matches actionSheet style via barStyle.
extern UIActionSheetStyle PSPDPFActionSheetStyleForBarButtonStyle(UIBarStyle barStyle, BOOL translucent);

// Returns toolbar height (44; except on iPhone)
extern CGFloat PSPDFToolbarHeightForOrientation(UIInterfaceOrientation orientation);
extern CGFloat PSPDFToolbarHeight(BOOL isSmall);

// combines fminf and fmaxf to limit a value between a range
extern CGFloat psrangef(float minRange, float value, float maxRange);

/// Trims down a string, removing characters like \n 's etc.
extern NSString *PSPDFTrimString(NSString *string);

// Checks if the current controller class is displayed in the popover (also checks UINavigationController)
extern BOOL PSPDFIsControllerClassInPopover(UIPopoverController *popoverController, Class controllerClass);

/// Initializes the keyboard lazily. (prevents this 1-sec delay when first accessing the keyboard)
extern void PSPDFCacheKeyboard(void);

// Time tracking. Returns time in nanoseconds. Use result/1E9 to print seconds.
extern double PSPDFPerformAndTrackTime(dispatch_block_t block, BOOL trackTime);

/// Global rotation lock/unlock for the whole app. Acts as a counter, can be called multiple times.
/// This is iOS6+ only, and only if compiled with the iOS 6 SDK (Since Apple drastically changed the way rotation works)
/// Older variants still need shouldAutorotate* handling in the view controllers.
extern BOOL PSPDFIsRotationLocked(void);
extern void PSPDFLockRotation(void);
extern void PSPDFUnlockRotation(void);

// Use special weak keyword
#if !defined ps_weak && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0 && !defined (PSPDF_ARC_IOS5_COMPILE)
#define ps_weak weak
#define __ps_weak __weak
#elif !defined ps_weak
#define ps_weak unsafe_unretained
#define __ps_weak __unsafe_unretained
#endif

#define PSRectClearCoords(_CGRECT) CGRectMake(0, 0, _CGRECT.size.width, _CGRECT.size.height)
#define PSIsIpad() ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define ps_swapf(a,b) { float c = (a); (a) = (b); (b) = c; }
#define BOXED(val) ({ typeof(val) _tmp_val = (val); [NSValue valueWithBytes:&(_tmp_val) objCType:@encode(typeof(val))]; })

#define PSPDF_KEYPATH(object, property) ((void)(NO && ((void)object.property, NO)), @#property)
#define PSPDF_KEYPATH_SELF(property) PSPDF_KEYPATH(self, property)

// Log helper
#import "PSPDFCache.h"
#ifdef kPSPDFKitDebugEnabled
#define PSPDFLogVerbose(fmt, ...) do { if(kPSPDFLogLevel >= PSPDFLogLevelVerbose) NSLog((@"%s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#define PSPDFLog(fmt, ...) do { if(kPSPDFLogLevel >= PSPDFLogLevelInfo) NSLog((@"%s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#define PSPDFLogWarning(fmt, ...) do { if(kPSPDFLogLevel >= PSPDFLogLevelWarning) NSLog((@"Warning: %s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#define PSPDFLogError(fmt, ...) do { if(kPSPDFLogLevel >= PSPDFLogLevelError) NSLog((@"Error: %s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#else
#define PSPDFLogVerbose(...)
#define PSPDFLog(...)
#define PSPDFLogError(...)
#define PSPDFLogWarning(...)
#endif

// Object tracker debug helper
#ifdef kPSPDFKitAllowMemoryDebugging
#define PSPDFLogMemory(fmt, ...) do { if(kPSPDFKitDebugMemory) NSLog((fmt), ##__VA_ARGS__); }while(0)
#define PSPDFRegisterObject(object) [[PSPDFCache sharedCache] registerObject:object]
#define PSPDFDeregisterObject(object) [[PSPDFCache sharedCache] deregisterObject:object]
#else
#define PSPDFLogMemory(fmt, ...)
#define PSPDFRegisterObject(object)
#define PSPDFDeregisterObject(object)
#endif

// iOS compatibility
#ifndef kCFCoreFoundationVersionNumber_iOS_5_0
#define kCFCoreFoundationVersionNumber_iOS_5_0 674.0
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
#define PSPDF_IF_IOS5_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_5_0) { __VA_ARGS__ }
#else
#define PSPDF_IF_IOS5_OR_GREATER(...)
#endif

// iOS 5.1
#ifndef kCFCoreFoundationVersionNumber_iOS_5_1
#define kCFCoreFoundationVersionNumber_iOS_5_1 690.0
#endif

#define PSPDF_IF_PRE_IOS5(...)  \
if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_5_0) { __VA_ARGS__ }

#ifndef kCFCoreFoundationVersionNumber_iOS_6_0
#define kCFCoreFoundationVersionNumber_iOS_6_0 788.0
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
#define PSPDF_IF_IOS6_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0) { __VA_ARGS__ }
#else
#define PSPDF_IF_IOS6_OR_GREATER(...)
#endif

#define PSPDF_IF_PRE_IOS6(...)  \
if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_6_0 || __IPHONE_OS_VERSION_MAX_ALLOWED < 60000) { __VA_ARGS__ }

#if TARGET_IPHONE_SIMULATOR
#define PSIsSimulator() YES
#define PSPDF_IF_SIMULATOR(...) { __VA_ARGS__ }
#define PSPDF_IF_NOT_SIMULATOR(...)
#else
#define PSIsSimulator() NO
#define PSPDF_IF_SIMULATOR(...)
#define PSPDF_IF_NOT_SIMULATOR(...) { __VA_ARGS__ }
#endif

// Starting with iOS6, dispatch queue's are objects and managed via ARC.
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000
#define PSPDFDispatchRelease(queue)
#else
#define PSPDFDispatchRelease(queue) dispatch_release(queue)
#endif

@interface NSArray (PSPDFArrayAccess)
- (id)ps_firstObject;
@end

// Smart little helper to find main thread hangs. Enable in appDidFinishLaunching.
// Only available with source code in DEBUG mode.
@interface PSPDFHangDetector : NSObject
+ (void)startHangDetector;
@end

// Force a category to be loaded when an app starts up, see http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html
#define PSPDF_FIX_CATEGORY_BUG(name) @interface PSPDF_FIX_CATEGORY_BUG_##name @end \
@implementation PSPDF_FIX_CATEGORY_BUG_##name @end

// Add support for subscripting to the iOS 5 SDK.
// See http://petersteinberger.com/blog/2012/using-subscripting-with-Xcode-4_4-and-iOS-4_3
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
@interface NSDictionary(PSPDFSubscriptingSupport)
- (id)objectForKeyedSubscript:(id)key;
@end
@interface NSMutableDictionary(PSPDFSubscriptingSupport)
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
@end
@interface NSArray(PSPDFSubscriptingSupport)
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
@end
@interface NSMutableArray(PSPDFSubscriptingSupport)
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
@end
#endif
