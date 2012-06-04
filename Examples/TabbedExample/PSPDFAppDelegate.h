//
//  PSPDFAppDelegate.h
//  TabbedExample
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFDocumentSelectorController.h"

@class PSPDFViewController;

@interface PSPDFAppDelegate : UIResponder <UIApplicationDelegate, PSPDFDocumentSelectorControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
