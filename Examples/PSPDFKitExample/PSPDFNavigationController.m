//
//  PSPDFNavigationController.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "PSPDFNavigationController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

// this is implemented, but not declared. we add the category to fix the warning
// (since super cannot be casted any longer in clang)
@interface UINavigationController(PSPDFKitExampleInternal)
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item;
@end

@implementation PSPDFNavigationController

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UINavigationBarDelegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    static BOOL change_once = NO;
    
    if (!change_once && PSIsIpad()) {
        change_once = YES;
        CATransition* transition = [CATransition animation];
        transition.duration = 0.3;
        transition.type = kCATransitionFade;
        transition.subtype = kCATransitionFromTop;
        
        [self.view.layer addAnimation:transition forKey:kCATransition];
        [self popViewControllerAnimated:NO];
        //[navigationBar popNavigationItemAnimated:NO];
        return NO;
    }else {
        change_once = NO;
        [super navigationBar:navigationBar shouldPopItem:item];
        return YES;
    }
}

@end
