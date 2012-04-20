//
//  MinimalExampleAppDelegate.h
//  MinimalExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

// if you use PSPDFKit.framework
#import <PSPDFKit/PSPDFKit.h>

// if you use PSPDFKit-lib.xcodeproj
//#import "PSPDFKit.h"

@interface MinimalExampleAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

// overridden PSPDFViewController to change back button
@interface PSMinimalExamplePDFViewController : PSPDFViewController

@end