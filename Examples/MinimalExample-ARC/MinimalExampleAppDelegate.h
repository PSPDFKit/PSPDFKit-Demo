//
//  MinimalExampleAppDelegate.h
//  MinimalExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

@interface MinimalExampleAppDelegate : UIResponder <UIApplicationDelegate, PSPDFViewControllerDelegate>

@property(strong, nonatomic) PSPDFViewController *pdfController;
@property(strong, nonatomic) UIWindow *window;

@end
