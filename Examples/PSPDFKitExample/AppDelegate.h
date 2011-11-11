//
//  AppDelegate.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#define kPSPDFExampleDebugEnabled

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

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    PSPDFGridController *gridController_;
    UINavigationController *navigationController_;
    UIWindow *window_;
}

@property (nonatomic, strong) IBOutlet UIWindow *window;
@property (nonatomic, strong) IBOutlet UINavigationController *navigationController;

@end
