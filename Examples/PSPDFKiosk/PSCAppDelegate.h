//
//  PSCAppDelegate.h
//  PSPDFKiosk
//
//  Created by Peter Steinberger on 12/14/12.
//  Copyright (c) 2012 PSPDFKit. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PSCGridViewController;

@interface PSCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PSCGridViewController *viewController;

@end
