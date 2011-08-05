//
//  PSPDFBasicViewController.m
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import "AppDelegate.h"
#import "PSPDFBasicViewController.h"

@implementation PSPDFBasicViewController

@synthesize popoverController = popoverController_;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)hidePopover:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[self.popoverController.contentViewController class]]) {
        PSELog(@"dismissing popover: %@", self.popoverController);
        [self.popoverController dismissPopoverAnimated:NO];
        self.popoverController = nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (id)init {
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePopover:) name:kDismissActivePopover object:nil];
    }
    return self;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.popoverController.delegate = nil;
    [popoverController_ release];
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)viewWillDisappear:(BOOL)animated {
    [self.popoverController dismissPopoverAnimated:animated];
    [super viewWillDisappear:animated];  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return PSIsIpad() ? YES : toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties

- (void)setPopoverController:(UIPopoverController *)popoverController {
    if (popoverController != popoverController_) {
        // hide last popup
        [popoverController_ dismissPopoverAnimated:NO];
        [popoverController_ autorelease];
        
        popoverController_ = [popoverController retain];
        popoverController_.delegate = self; // set delegate to be notified when popopver controller closes!
    }
}

- (BOOL)isVisible {
    return self.view.window != nil;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIPopoverController

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController; {
    self.popoverController = nil;
}

@end
