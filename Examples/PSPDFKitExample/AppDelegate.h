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

@class PSPDFGridController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    PSPDFGridController *gridController_;
    UINavigationController *navigationController_;
    UIWindow *window_;
    NSArray *magazineFolders_;
}

- (void)updateFolders;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@property (nonatomic, copy, readonly) NSArray *magazineFolders;

@end
