//
//  PSPDFKitGlobal.h
//  PSPDFKit
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "PSPDFCache.h"

/// *completely* disables logging. not advised to change this, use kPSPDFLogLevel instead.
#define kPSPDFKitDebugEnabled

/// If disabled, kPSPDFKitDebugMemory has no effect. Also checks for NS_BLOCK_ASSERTIONS to be NOT set.
#define kPSPDFKitAllowMemoryDebugging

/// If enabled, this shows some additional log data for specific features to track time.
/// This should only be enabled for debugging.
//#define kPSPDFBenchmark

extern NSString *const kPSPDFErrorDomain;

enum {
    PSPDFErrorCodePageInvalid = 100,
    PSPDFErrorCodeUnableToOpenPDF = 200,
    PSPDFErrorCodeUnknown = 900,    
}typedef PSPDFErrorCode;


// defines a basic void block
typedef void(^PSPDFBasicBlock)(void);

enum {
    PSPDFLogLevelNothing = 0,
    PSPDFLogLevelError,   
    PSPDFLogLevelWarning,
    PSPDFLogLevelInfo,
    PSPDFLogLevelVerbose
}typedef PSPDFLogLevel;

/// set log level.
extern PSPDFLogLevel kPSPDFLogLevel; // defaults to PSPDFLogLevelError

/// settings for animation of pages, global
enum {
    PSPDFAnimateNever,
    PSPDFAnimateModernDevices,
    PSPDFAnimateEverywhere
}typedef PSPDFAnimate;

extern PSPDFAnimate kPSPDFAnimateOption; /// defaults to PSPDFAnimateModernDevices

/// default time to animate pdf views. Defaults to 0.15
extern CGFloat kPSPDFKitPDFAnimationDuration;

/// available zoom levels for CATiledLayer. Defaults to 4 or 5 on modern devices. Affects PSPDFTilingView.
/// Setting this too high will result in a memory crash.
/// If set too low, you get pixelerated text. Too high, and the render-process will be invoked *while* zooming,
/// resulting in text becoming somewhat sharp, then sharp (when the correct zoom level is rendered)
extern NSUInteger kPSPDFKitZoomLevels;

extern CGFloat kPSPDFKitHUDTransparency;

/// optionally enable scrollbar debugging.
extern BOOL kPSPDFKitDebugScrollViews;

/// enable to track down memory issues
extern BOOL kPSPDFKitDebugMemory;

/// improves scroll performance
extern CGFloat kPSPDFInitialAnnotationLoadDelay;

/// detect if it's a crappy device (everything before iPhone4 or iPad2 is defined as "crap")
extern BOOL PSPDFIsCrappyDevice(void);

/// evaluates if devices is modern enough to support proper animation (depends on kPSPDFAnimateOption setting)
extern BOOL PSPDFShouldAnimate(void);

// drawing helper
extern inline void DrawPSPDFKit(CGContextRef context);

/// class name for PSPDFCache singleton. Change this at the very beginning of your app to support a custom subclass.
extern NSString *kPSPDFCacheClassName;

/// class name for PSPDFIconGenerator singleton. Change this at the very beginning of your app to support a custom subclass.
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
extern NSString *PSPDFResolvePathNames(NSString *path, NSString *fallbackPath);
extern BOOL PSPDFResolvePathNamesInMutableString(NSMutableString *mutableString, NSString *fallbackPath);

/// If you need the 1.9-style path resolving (no marker = bundle path, not pdf path) set this to yes. Defaults to NO.
extern BOOL PSPDFResolvePathNamesEnableLegacyBehavior;

/// Queries subviews for a specific class prefix. Usually used for subview-hacking/workarounds.
extern UIView *PSPDFGetViewInsideView(UIView *view, NSString *classNamePrefix);

// helper for deadlock-free dispatch_sync.
extern inline void pspdf_dispatch_sync_reentrant(dispatch_queue_t queue, dispatch_block_t block);

// use special weak keyword
#if !defined ps_weak && __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0 && !defined (PSPDF_ARC_IOS5_COMPILE)
#define ps_weak weak
#define __ps_weak __weak
#define ps_nil(x)
#elif !defined ps_weak
#define ps_weak unsafe_unretained
#define __ps_weak __unsafe_unretained
#define ps_nil(x) x = nil
#endif

// view helper
#define PSRectClearCoords(_CGRECT) CGRectMake(0, 0, _CGRECT.size.width, _CGRECT.size.height)
#define MCReleaseNil(x) [x release], x = nil
#define MCReleaseViewNil(x) do { [x removeFromSuperview], [x release], x = nil; } while (0)
#define PSAppStatusBarOrientation ([[UIApplication sharedApplication] statusBarOrientation])
#define PSIsPortrait()  UIInterfaceOrientationIsPortrait(PSAppStatusBarOrientation)
#define PSIsLandscape() UIInterfaceOrientationIsLandscape(PSAppStatusBarOrientation)
#define PSIsIpad() ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

// log helper
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

// object tracker debug helper
#ifdef kPSPDFKitAllowMemoryDebugging
#define PSPDFLogMemory(fmt, ...) do { if(kPSPDFKitDebugMemory) NSLog((fmt), ##__VA_ARGS__); }while(0)
#define PSPDFRegisterObject(object) [[PSPDFCache sharedPSPDFCache] registerObject:object]
#define PSPDFDeregisterObject(object) [[PSPDFCache sharedPSPDFCache] deregisterObject:object]
#else
#define PSPDFLogMemory(fmt, ...)
#define PSPDFRegisterObject(object)
#define PSPDFDeregisterObject(object)
#endif

// swapper
#define ps_swap(a,b) {  \
int c = (a);         \
(a) = (b);           \
(b) = c;             \
}

#define ps_swapf(a,b) { \
float c = (a);       \
(a) = (b);           \
(b) = c;             \
}

// Force a category to be loaded when an app starts up, see http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html
#define PSPDF_FIX_CATEGORY_BUG(name) @interface PSPDF_FIX_CATEGORY_BUG_##name @end \
@implementation PSPDF_FIX_CATEGORY_BUG_##name @end

// iOS compatibility
#ifndef kCFCoreFoundationVersionNumber_iOS_4_0
#define kCFCoreFoundationVersionNumber_iOS_4_0 550.32
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
#define PSPDF_IF_IOS4_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_4_0) \
{ \
__VA_ARGS__ \
}
#else
#define PSPDF_IF_IOS4_OR_GREATER(...)
#endif

#define PSPDF_IF_PRE_IOS4(...)  \
if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_4_0)  \
{ \
__VA_ARGS__ \
}

#ifndef kCFCoreFoundationVersionNumber_iOS_5_0
#define kCFCoreFoundationVersionNumber_iOS_5_0 674.0
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
#define PSPDF_IF_IOS5_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_5_0) \
{ \
__VA_ARGS__ \
}
#else
#define PSPDF_IF_IOS5_OR_GREATER(...)
#endif

#define PSPDF_IF_PRE_IOS5(...)  \
if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_5_0)  \
{ \
__VA_ARGS__ \
}


#ifndef kCFCoreFoundationVersionNumber_iOS_6_0
#define kCFCoreFoundationVersionNumber_iOS_6_0 690.0
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
#define PSPDF_IF_IOS6_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_6_0) \
{ \
__VA_ARGS__ \
}
#else
#define PSPDF_IF_IOS6_OR_GREATER(...)
#endif

#define PSPDF_IF_PRE_IOS6(...)  \
if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iOS_6_0)  \
{ \
__VA_ARGS__ \
}

// Add support for subscripting to the iOS 5 SDK.
#if __IPHONE_OS_VERSION_MAX_ALLOWED < 60000
@interface NSObject (PSPDFSubscriptingSupport)

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)idx;
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;
- (id)objectForKeyedSubscript:(id)key;

@end
#endif

