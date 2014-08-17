//
//  PSCStoryboardsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCExample.h"

@interface PSCStoryboardsInitWithStoryboardExample : PSCExample @end
@implementation PSCStoryboardsInitWithStoryboardExample

- (instancetype)init {
    if (self = [super init]) {
        self.title = @"Init with Storyboard";
        self.category = PSCExampleCategoryStoryboards;
        self.priority = 10;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunnerDelegate>)delegate {
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateInitialViewController];
    return controller;
}

@end
