//
//  PSPDFPageFlipViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFFlipViewController.h"
#import "PSPDFTransitionViewController.h"

@interface PSPDFPageFlipViewController : PSPDFFlipViewController<PSPDFTransitionViewControllerDelegate, PSPDFFlipViewControllerDelegate, PSPDFFlipViewControllerDataSource>

- (id)initWithTransitionController:(PSPDFTransitionViewController *)transitionController;

@property(nonatomic, ps_weak) PSPDFTransitionViewController *transitionController;

@end
