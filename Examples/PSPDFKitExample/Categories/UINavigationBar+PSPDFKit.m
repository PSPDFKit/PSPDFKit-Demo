//
//  UINavigationBar+PSPDFKit.m
//  PSPDFKit
//
//  Created by Peter Steinberger on 11/20/11.
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import "UINavigationBar+PSPDFKit.h"
#import <objc/runtime.h>

@implementation UINavigationBar(PSPDFKit) 

// swizzle to remove the pop-animation from the navigation controller.
- (UINavigationItem *)pspdf_popNavigationItemAnimated:(BOOL)animated {
    UINavigationController *navController = (UINavigationController *)([UIApplication sharedApplication].keyWindow.rootViewController);
    if ([navController.topViewController isKindOfClass:[PSPDFViewController class]]) {
        animated = NO;
    }
    
    return [self pspdf_popNavigationItemAnimated:animated];
}

+ (void)pspdfkit_swizzleNavigationMethodes {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @try {
            Method origMethod = class_getInstanceMethod([UINavigationBar class], @selector(popNavigationItemAnimated:));
            Method overrideMethod = class_getInstanceMethod([UINavigationBar class], @selector(pspdf_popNavigationItemAnimated:));
            method_exchangeImplementations(origMethod, overrideMethod);
        }
        @catch (NSException *exception) {
            PSPDFLogWarning(@"swizzling failed with exception: %@", exception);
        }
    });
}

@end
