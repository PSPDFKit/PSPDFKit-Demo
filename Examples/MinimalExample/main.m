//
//  main.m
//  MinimalExample
//
//  Created by Peter Steinberger on 7/26/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MinimalExampleAppDelegate.h"

int main(int argc, char *argv[])
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil,  NSStringFromClass([MinimalExampleAppDelegate class]));
    [pool release];
    return retVal;
}
