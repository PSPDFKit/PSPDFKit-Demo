//
//  MinimalExampleAppDelegate.h
//  MinimalExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MinimalExampleAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

// overridden PSPDFViewController to change back button
@interface PSMinimalExamplePDFViewController : PSPDFViewController

@end