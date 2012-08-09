//
//  PSPDFBasicViewController.m
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSCBasicViewController.h"

@implementation PSCBasicViewController

@synthesize popoverController = popoverController_;

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Private

- (void)hidePopover:(NSNotification *)notification {
    if ([notification.object isKindOfClass:[self.popoverController.contentViewController class]]) {
        PSCLog(@"dismissing popover: %@", self.popoverController);
        [self.popoverController dismissPopoverAnimated:NO];
        self.popoverController = nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
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
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIView

- (void)viewWillDisappear:(BOOL)animated {
    [self.popoverController dismissPopoverAnimated:animated];
    [super viewWillDisappear:animated];  
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties

- (void)setPopoverController:(UIPopoverController *)popoverController {
    if (popoverController != popoverController_) {
        // hide last popup
        [popoverController_ dismissPopoverAnimated:NO];
        
        popoverController_ = popoverController;
        popoverController_.delegate = self; // set delegate to be notified when popopver controller closes!
    }
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UIPopoverController

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popoverController = nil;
}

@end
