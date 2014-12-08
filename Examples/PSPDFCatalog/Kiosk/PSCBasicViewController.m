//
//  PSPDFBasicViewController.m
//  PSPDFCatalog
//
//  Copyright (c) 2011-2015 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCBasicViewController.h"
#import "PSCAvailability.h"

#if !__has_feature(objc_arc)
#error "Compile this file with ARC"
#endif

@implementation PSCBasicViewController

@synthesize popoverController = popoverController_;

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - NSObject

- (instancetype)init {
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
    self.popoverController = nil;
    [super viewWillDisappear:animated];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Public

- (void)closeModalView {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Properties

- (void)setPopoverController:(UIPopoverController *)popoverController {
    if (popoverController != popoverController_) {
        // hide last popup
        [popoverController_ dismissPopoverAnimated:NO];

        popoverController_ = popoverController;
        popoverController_.delegate = self; // set delegate to be notified when popover controller closes!
    }
}

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
#pragma mark - UIPopoverController

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    self.popoverController = nil;
}

@end
