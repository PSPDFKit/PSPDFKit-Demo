//
//  PSCStoryboardsExample.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCStoryboardsExample.h"

@implementation PSCStoryboardsInitWithStoryboardExample

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - PSCExample

- (id)init {
    if (self = [super init]) {
        self.title = @"Init with Storyboard";
        self.category = PSCExampleCategoryStoryboards;
        self.priority = 10;
    }
    return self;
}

- (UIViewController *)invokeWithDelegate:(id<PSCExampleRunner>)delegate {
    
    UIViewController *controller = nil;
    @try {
        // will throw an exception if the file MainStoryboard.storyboard is missing
        controller = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateInitialViewController];
    }
    @catch (NSException *exception) {
        [[[UIAlertView alloc] initWithTitle:@"Warning" message:@"You need to manually add the file MainStoryboard.storyboard." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    }
    return controller;
}

@end
