//
//  PSPDFKitGlobal.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/21/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFCache.h"

// *completely* disables logging. not advised. use kPSPDFKitDebugLogLevel instead.
#define kPSPDFKitDebugEnabled

// if disabled, kPSPDFKitDebugMemory has no effect.
#define kPSPDFKitAllowMemoryDebugging

extern CGFloat kPSPDFKitHUDTransparency;

// return status bar width, orientation corrected, and only on iPad
CGFloat PSStatusBarHeight(void);

/// detect if it's a crappy device (everything before iPhone4 or iPad2 is defined as "crap")
BOOL PSPDFIsCrappyDevice(void);

/// evaluates if devices is modern enough to support proper animation (depends on kPSPDFAnimateOption setting)
BOOL PSPDFShouldAnimate(void);

/// helper to calculate new rect for specific scale
CGSize PSPDFSizeForScale(CGRect rect, CGFloat scale);

/// default time to animate pdf views. Defaults to 0.15
extern CGFloat kPSPDFKitPDFAnimationDuration;

/// available zoom levels for CATiledLayer. Defaults to 4. Affects PSPDFTilingView.
/// Setting this too high will result in a memory crash. 4 is a sensible default, you may increase it up to 5.
/// If set too low, you get pixelerated text. Too high, and the render-process will be invoked *while* zooming,
/// resulting in text becoming somewhat sharp, then sharp (when the correct zoom level is rendered)
extern NSUInteger kPSPDFKitZoomLevels;

enum {
    PSPDFLogLevelNothing,
    PSPDFLogLevelError,   
    PSPDFLogLevelWarning,
    PSPDFLogLevelInfo,
    PSPDFLogLevelVerbose
}typedef PSPDFLogLevel;

// set log level.
extern PSPDFLogLevel kPSPDFKitDebugLogLevel; // defaults to PSPDFLogLevelError


/// settings for animation of pages, global
enum {
    PSPDFAnimateNever,
    PSPDFAnimateModernDevices,
    PSPDFAnimateEverywhere
}typedef PSPDFAnimate;

extern PSPDFAnimate kPSPDFAnimateOption; /// defaults to PSPDFAnimateModernDevices

// optionally enable scrollbar debugging.
extern BOOL kPSPDFKitDebugScrollViews;

// enable to track down memory issues
extern BOOL kPSPDFKitDebugMemory;

#define PSRectClearCoords(_CGRECT) CGRectMake(0, 0, _CGRECT.size.width, _CGRECT.size.height)
#define MCReleaseNil(x) [x release], x = nil
#define MCReleaseViewNil(x) do { [x removeFromSuperview], [x release], x = nil; } while (0)

#define PSAppStatusBarOrientation ([[UIApplication sharedApplication] statusBarOrientation])
#define PSIsPortrait()  UIInterfaceOrientationIsPortrait(PSAppStatusBarOrientation)
#define PSIsLandscape() UIInterfaceOrientationIsLandscape(PSAppStatusBarOrientation)
#define PSIsIpad() ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

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

// draw demo mode code
#ifdef kPSPDFKitDemoMode
#define DrawPSPDFKitDemo(context); \
NSString *text = @"PSPDFKit DEMO"; \
NSUInteger fontSize = 30; \
CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor); \
CGContextSelectFont(context, "Helvetica-Bold", fontSize, kCGEncodingMacRoman); \
CGAffineTransform xform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0); \
CGContextSetTextMatrix(context, xform); \
CGContextSetTextDrawingMode(context, kCGTextFill); \
CGContextSetTextPosition(context, 30.0f, 30.0f + round(fontSize / 4.0f)); \
CGContextShowText(context, [text UTF8String], strlen([text UTF8String]));
#else
#define DrawPSPDFKitDemo(context);
#endif
