//
//  PSPDFKitGlobal.h
//  PSPDFKit
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFCache.h"

// version string. use PSPDFVersionString() to get.
#define kPSPDFKitVersionString @"1.7.4"

/// *completely* disables logging. not advised. use kPSPDFKitDebugLogLevel instead.
#define kPSPDFKitDebugEnabled

/// if disabled, kPSPDFKitDebugMemory has no effect.
#define kPSPDFKitAllowMemoryDebugging

enum {
    PSPDFLogLevelNothing = 0,
    PSPDFLogLevelError,   
    PSPDFLogLevelWarning,
    PSPDFLogLevelInfo,
    PSPDFLogLevelVerbose
}typedef PSPDFLogLevel;

/// set log level.
extern PSPDFLogLevel kPSPDFKitDebugLogLevel; // defaults to PSPDFLogLevelError

/// settings for animation of pages, global
enum {
    PSPDFAnimateNever,
    PSPDFAnimateModernDevices,
    PSPDFAnimateEverywhere
}typedef PSPDFAnimate;

extern PSPDFAnimate kPSPDFAnimateOption; /// defaults to PSPDFAnimateModernDevices

/// default time to animate pdf views. Defaults to 0.15
extern CGFloat kPSPDFKitPDFAnimationDuration;

/// available zoom levels for CATiledLayer. Defaults to 4. Affects PSPDFTilingView.
/// Setting this too high will result in a memory crash. 4 is a sensible default, you may increase it up to 5.
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
BOOL PSPDFIsCrappyDevice(void);

/// evaluates if devices is modern enough to support proper animation (depends on kPSPDFAnimateOption setting)
BOOL PSPDFShouldAnimate(void);

/// helper to calculate new rect for specific scale
CGSize PSPDFSizeForScale(CGRect rect, CGFloat scale);

// drawing helper
extern inline void DrawPSPDFKit(CGContextRef context);

/// class name for PSPDFCache singleton. Change this at the very beginning of your app to support a custom subclass.
extern NSString *kPSPDFCacheClassName;

/// Get current PSPDFKit version.
extern NSString *PSPDFVersionString(void);

/// Localizes strings.
extern NSString *PSPDFLocalize(NSString *stringToken);

// Allows to set a custom dictionary that contains dictionaries with language locales.
// Will override localization found in the bundle, if a value is found.
// Falls back to "en" if localization key is not found in dictionary.
extern void PSPDFSetLocalizationDictionary(NSDictionary *localizationDict);

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
#define PSPDFLogVerbose(fmt, ...) do { if(kPSPDFKitDebugLogLevel >= PSPDFLogLevelVerbose) NSLog((@"%s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#define PSPDFLog(fmt, ...) do { if(kPSPDFKitDebugLogLevel >= PSPDFLogLevelInfo) NSLog((@"%s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#define PSPDFLogWarning(fmt, ...) do { if(kPSPDFKitDebugLogLevel >= PSPDFLogLevelWarning) NSLog((@"Warning: %s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#define PSPDFLogError(fmt, ...) do { if(kPSPDFKitDebugLogLevel >= PSPDFLogLevelError) NSLog((@"Error: %s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
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

// synthesize singleton helper
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)shared##classname \
{ \
static dispatch_once_t pred; \
dispatch_once(&pred, ^{ shared##classname = [[self alloc] init]; }); \
return shared##classname; \
} \
\
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\
- (id)retain \
{ \
return self; \
} \
\
- (NSUInteger)retainCount \
{ \
return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
return self; \
}

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
#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_4_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_4_0 550.32
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
#define PSPDF_IF_IOS4_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_4_0) \
{ \
__VA_ARGS__ \
}
#else
#define PSPDF_IF_IOS4_OR_GREATER(...)
#endif

#define PSPDF_IF_PRE_IOS4(...)  \
if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iPhoneOS_4_0)  \
{ \
__VA_ARGS__ \
}

#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_5_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_5_0 674.0
#endif
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 50000
#define PSPDF_IF_IOS5_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_5_0) \
{ \
__VA_ARGS__ \
}
#else
#define PSPDF_IF_IOS5_OR_GREATER(...)
#endif

#define PSPDF_IF_PRE_IOS5(...)  \
if (kCFCoreFoundationVersionNumber < kCFCoreFoundationVersionNumber_iPhoneOS_5_0)  \
{ \
__VA_ARGS__ \
}

