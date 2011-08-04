//
//  PSPDFKitGlobal.h
//  PSPDFKit
//
//  Created by Peter Steinberger on 7/21/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

// *completely* disables logging. not advised. use kPSPDFKitDebugLogLevel instead.
#define kPSPDFKitDebugEnabled

// return status bar width, orientation corrected, and only on iPad
CGFloat PSStatusBarHeight(void);

enum {
    PSPDFLogLevelNothing,
    PSPDFLogLevelError,    
    PSPDFLogLevelInfo,
    PSPDFLogLevelVerbose
}typedef PSPDFLogLevel;

// set log level.
extern PSPDFLogLevel kPSPDFKitDebugLogLevel; // defaults to PSPDFLogLevelError

// optionally enable scrollbar debugging.
extern BOOL kPSPDFKitDebugScrollViews;

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
#define PSPDFLogError(fmt, ...) do { if(kPSPDFKitDebugLogLevel >= PSPDFLogLevelError) NSLog((@"Error: %s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#else
#define PSPDFLogVerbose(...)
#define PSPDFLog(...)
#define PSPDFLogError(...)
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


// draw demo mode code
#ifdef kPSPDFKitDemoMode
#define DrawPSPDFKitDemo(); \
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
#define DrawPSPDFKitDemo();
#endif
