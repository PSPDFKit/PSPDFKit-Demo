//
//  PSPDFFormInputAccessoryView.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import "PSPDFFormInputAccessoryViewDelegate.h"

// Notification when someone pressed "Clear Field".
extern NSString *const PSPDFFormInputAccessoryViewDidPressClearButtonNotification;

/// Toolbar for Next|Previous controls for Form Elements.
@interface PSPDFFormInputAccessoryView : UIView

/// Designated initializer.
- (id)initWithFrame:(CGRect)frame delegate:(id<PSPDFFormInputAccessoryViewDelegate>)delegate;

/// Display Done button. Defaults to YES.
@property (nonatomic) BOOL displayDoneButton;
@property (nonatomic) BOOL displayClearButton;

/// The input accessory delegate.
@property (nonatomic, weak) id<PSPDFFormInputAccessoryViewDelegate> delegate;

/// Trigger toolbar update.
- (void)updateToolbar;

@end


@interface PSPDFFormInputAccessoryView (SubclassingHooks)

// Allow button customizations. Never return nil for these!
@property (nonatomic, strong, readonly) UIBarButtonItem *nextButton;
@property (nonatomic, strong, readonly) UIBarButtonItem *prevButton;
@property (nonatomic, strong, readonly) UIBarButtonItem *doneButton;
@property (nonatomic, strong, readonly) UIBarButtonItem *clearButton;

- (IBAction)nextButtonPressed:(id)sender;
- (IBAction)prevButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;

@end
