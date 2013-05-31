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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@class CATransition;

/// *Completely* disables logging. not advised to change this, use kPSPDFLogLevel instead.
#define kPSPDFKitDebugEnabled

// Debug feature
//#define kPSPDFEnableAllBarButtonItems

extern NSString *const kPSPDFErrorDomain;

typedef NS_ENUM(NSInteger, PSPDFErrorCode) {
    PSPDFErrorCodePageInvalid = 100,
    PSPDFErrorCodeUnableToOpenPDF = 200,
    PSPDFErrorCodeUnableToGetPageReference = 210,
    PSPDFErrorCodeUnableToGetStream = 220,
    PSPDFErrorCodePageRenderSizeIsEmpty = 220,
    PSPDFErrorCodePageRenderClipRectTooLarge = 230,
    PSPDFErrorCodePageRenderGraphicsContextNil = 240,
    PSPDFErrorCodeDocumentLocked = 300,
    PSPDFErrorCodeFailedToLoadAnnotations = 400,
    PSPDFErrorCodeFailedToWriteAnnotations = 410,
    PSPDFErrorCodeFailedToLoadBookmarks = 450,
    PSPDFErrorCodeOutlineParser = 500,
    PSPDFErrorCodeUnableToConvertToDataRepresentation = 600,
    PSPDFErrorCodeRemoveCacheError = 700,
    PSPDFErrorCodeFailedToConvertToPDF = 800,
    PSPDFErrorCodeFailedToGeneratePDFInvalidArguments = 810,
    PSPDFErrorCodeFailedToGeneratePDFDocumentInvalid = 820,
    PSPDFErrorCodeFailedToUpdatePageObject = 850,
    PSPDFErrorCodeUnknown = 900,
};

/// Global PSPDFKit log level.
/// Note that PSPDFLogLevelVerbose will severely slow down the whole application.
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

/// Enable to use less memory. Some operations might need more time to complete, and caching will be less efficient. Defaults to NO.
/// This might be useful if your own app needs a lot of memory or you're seeing memory related crashes with complex PDFs.
extern BOOL kPSPDFLowMemoryMode;

/// Default time to animate pdf views. Defaults to 0.1. Only animates from thumbnail to sharp page, and only on modern devices.
extern CGFloat kPSPDFAnimationDuration;

/// Evaluates if devices is modern enough to support proper animation (depends on kPSPDFAnimateOption setting)
extern BOOL PSPDFShouldAnimate(void);

/// Improves scroll performance.
extern CGFloat kPSPDFInitialAnnotationLoadDelay;

/// Detect if it's a crappy device (everything before iPhone4 or iPad2 is defined as "crap")
extern BOOL PSPDFIsCrappyDevice(void);

// Returns the (localized) name of the current app.
extern NSString *PSPDFAppName(void);

/// Get current PSPDFKit version.
extern NSString *PSPDFVersionString(void);

/// Access the PSPDFKit.bundle.
extern NSBundle *PSPDFKitBundle(void);

/// Localizes strings.
/// Will first look up the string in the PSPDFKit.bundle
extern NSString *PSPDFLocalize(NSString *stringToken);

/// Allows to set a custom dictionary that contains dictionaries with language locales.
/// Will override localization found in the bundle, if a value is found.
/// Falls back to "en" if localization key is not found in dictionary.
extern void PSPDFSetLocalizationDictionary(NSDictionary *localizationDict);

/// Register a custom block that handles translation.
/// If this block returns nil, the PSPDFKit.bundle + localizationDict will be used.
extern void PSPDFSetLocalizationBlock(NSString *(^localizationBlock)(NSString *stringToLocalize));

/// Resolves paths like "Documents" or "Bundle" to their real path.
/// If no name is found, the bundle string is always attached, unless fallbackPath is set.
/// resolveUnknownDocumentBlock gets called if a token is found that isn't recognized.
/// Resolvable tokens must start with a slash. (e.g. /Bundle/Samples)
/// If the path is from root directory, it won't be resolved.
extern NSString *PSPDFResolvePathNames(NSString *path, NSString *fallbackPath);

extern BOOL PSPDFResolvePathNamesInMutableString(NSMutableString *mutableString, NSString *fallbackPath, NSString *(^resolveUnknownPathBlock)(NSString *unknownPath));

/// Removes the ".pdf" or a cased derivation of it from the fileName, if it exists.
extern NSString *PSPDFStripPDFFileType(NSString *pdfFileName);

/// Queries subviews for a specific class prefix. Usually used for subview-querying.
extern UIView *PSPDFGetViewInsideView(UIView *view, NSString *classNamePrefix);

// Compensates the effect of SLOW ANIMATIONS in the iOS Simulator.
// Use for CATransition etc. UIKit animations are automatically slowed down.
extern CGFloat PSPDFSimulatorAnimationDragCoefficient(void);

// Creates a default, 0.25sec long fade transition
extern CATransition *PSPDFFadeTransition(void);

// Creates a fade transition with 'duration' timing.
extern CATransition *PSPDFFadeTransitionWithDuration(CGFloat duration);

// UIKit sometimes gets the toolbar position wrong, when we show/hide things at the "wrong" time.
// While I see this as a bug and have placed some rdars on it, here's a simple workaround.
// @warning 'animated' is currently ignored.
extern void PSPDFFixNavigationBarForNavigationControllerAnimated(UINavigationController *navController, BOOL animated);

// Matches actionSheet style via barStyle.
extern UIActionSheetStyle PSPDFActionSheetStyleForBarButtonStyle(UIBarStyle barStyle, BOOL translucent);

// Returns toolbar height (44; except on iPhone)
extern CGFloat PSPDFToolbarHeightForOrientation(UIInterfaceOrientation orientation);

extern CGFloat PSPDFToolbarHeight(BOOL isSmall);

// Compares sizes and allows aspect ratio changes.
extern BOOL PSPDFSizeAspectRatioEqualToSize(CGSize containerSize, CGSize size);

// combines fminf and fmaxf to limit a value between a range
extern CGFloat psrangef(float minRange, float value, float maxRange);

// Trims down a string, removing characters like \n 's etc.
extern NSString *PSPDFTrimString(NSString *string);

// Checks if the current controller class is displayed in the popover (also checks UINavigationController)
extern BOOL PSPDFIsControllerClassInPopoverAndVisible(UIPopoverController *popoverController, Class controllerClass);

// Convert an NSArray of NSNumber's to an NSIndexSet
extern NSIndexSet *PSPDFIndexSetFromArray(NSArray *array);

/// Initializes the keyboard lazily. (prevents this 1-sec delay when first accessing the keyboard)
extern void PSPDFCacheKeyboard(void);

// Time tracking. Returns time in nanoseconds. Use result/1E9 to print seconds.
extern double PSPDFPerformAndTrackTime(dispatch_block_t block, BOOL trackTime);

// Global rotation lock/unlock for the whole app. Acts as a counter, can be called multiple times.
// This is iOS6+ only, and only if compiled with the iOS 6 SDK (Since Apple drastically changed the way rotation works)
// Older variants still need shouldAutorotate* handling in the view controllers.
extern BOOL PSPDFIsRotationLocked(void);
extern void PSPDFLockRotation(void);
extern void PSPDFUnlockRotation(void);

// Returns a unique temporary file URL.
extern NSURL *PSPDFTempFileURLWithPathExtension(NSString *prefix, NSString *pathExtension);

// Returns whether both objects are identical or equal via -isEqual.
extern BOOL PSPDFEqualObjects(id obj1, id obj2);

#define PSIsIpad() (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define ps_swapf(a,b) { float c = (a); (a) = (b); (b) = c; }
#define BOXED(val) ({ typeof(val) _tmp_val = (val); [NSValue valueWithBytes:&(_tmp_val) objCType:@encode(typeof(val))]; })

// Compiler-checked selectors
#define PSPDF_KEYPATH(object, property) ((void)(NO && ((void)object.property, NO)), @#property)
#define PSPDF_KEYPATH_SELF(property) PSPDF_KEYPATH(self, property)
#if DEBUG
#define PROPERTY(propName) NSStringFromSelector(@selector(propName))
#else
#define PROPERTY(propName) @#propName
#endif

// A better assert. NSAssert is too runtime dependant, and assert() doesn't log.
// http://www.mikeash.com/pyblog/friday-qa-2013-05-03-proper-use-of-asserts.html
// Accepts both:
// - PSPDFAssert(x > 0);
// - PSPDFAssert(y > 3, @"Bad value for y");
#define PSPDFAssert(expression, ...) \
do { if(!(expression)) { \
NSLog(@"%@", [NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@", #expression, __PRETTY_FUNCTION__, __FILE__, __LINE__, [NSString stringWithFormat:@"" __VA_ARGS__]]); \
abort(); }} while(0)

// Defines a yet undocumented method to add a warning if super isn't called.
#ifndef NS_REQUIRES_SUPER
#if __has_attribute(objc_requires_super)
#define NS_REQUIRES_SUPER __attribute((objc_requires_super))
#else
#define NS_REQUIRES_SUPER
#endif
#endif

// Log helper
#ifdef kPSPDFKitDebugEnabled
#define PSPDFLogVerbose(fmt, ...) do { if (kPSPDFLogLevel >= PSPDFLogLevelVerbose) NSLog((@"%s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#define PSPDFLog(fmt, ...) do { if (kPSPDFLogLevel >= PSPDFLogLevelInfo) NSLog((@"%s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#define PSPDFLogWarning(fmt, ...) do { if (kPSPDFLogLevel >= PSPDFLogLevelWarning) NSLog((@"Warning: %s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#define PSPDFLogError(fmt, ...) do { if (kPSPDFLogLevel >= PSPDFLogLevelError) NSLog((@"Error: %s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); }while(0)
#else
#define PSPDFLogVerbose(...)
#define PSPDFLog(...)
#define PSPDFLogError(...)
#define PSPDFLogWarning(...)
#endif

// iOS compatibility
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

// Starting with iOS6, dispatch queue's can be objects and managed via ARC.
#if OS_OBJECT_USE_OBJC
#define PSPDFDispatchRelease(queue)
#else
#define PSPDFDispatchRelease(queue) if (queue) dispatch_release(queue)
#endif

@interface NSArray (PSPDFCollections)
- (id)ps_firstObject;
@end

@interface NSMutableArray (PSPDFCollections)
- (void)ps_addObjectSafe:(id)anObject;

- (void)ps_addObjectsFromArraySafe:(NSArray *)otherArray;
@end

// Force a category to be loaded when an app starts up, see http://developer.apple.com/library/mac/#qa/qa2006/qa1490.html
#define PSPDF_FIX_CATEGORY_BUG(name) @interface PSPDF_FIX_CATEGORY_BUG_##name : NSObject @end \
@implementation PSPDF_FIX_CATEGORY_BUG_##name @end
