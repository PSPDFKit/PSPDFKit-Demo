//
//  MinimalExampleAppDelegate.h
//  MinimalExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

// remove the ifdef in your project
#ifndef PSPDFKIT_USE_SOURCE
// if you use PSPDFKit.framework
#import <PSPDFKit/PSPDFKit.h>
#else
// if you use PSPDFKit-lib.xcodeproj
#import "PSPDFKit.h"
#endif

@interface MinimalExampleAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
