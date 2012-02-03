//
//  AppDelegate.h
//  PSPDFKitExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#define kPSPDFExampleDebugEnabled

// ARC is compatible with iOS 4.0 upwards, but you need at least Xcode 4.2 with Clang LLVM 3.0 to compile it.
#if !defined(__clang__) || __clang_major__ < 3
#error This project must be compiled with ARC (Xcode 4.2+ with LLVM 3.0 and above)
#endif

// uncomment to try out QuickLook instead of PSPDFKit
//#define kPSPDFQuickLookEngineEnabled

#ifdef kPSPDFExampleDebugEnabled
#define PSELog(fmt, ...) NSLog((@"%s/%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define PSELog(...)
#endif

#define _(s) NSLocalizedString(s,s)
#define XAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define kPSPDFMagazineJSONURL @"http://pspdfkit.com/magazines.json"

@class PSPDFGridController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    PSPDFGridController *gridController_;
    UINavigationController *navigationController_;
    UIWindow *window_;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;

@end
