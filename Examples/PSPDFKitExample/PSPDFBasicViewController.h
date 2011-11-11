//
//  PSPDFBasicViewController.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kDismissActivePopover @"kDismissActivePopover"

@interface PSPDFBasicViewController : UIViewController <UIPopoverControllerDelegate> {
    UIPopoverController *popoverController_;
}

@property (nonatomic, assign, readonly, getter=isVisible) BOOL visible;
@property (nonatomic, strong) UIPopoverController *popoverController;

@end
