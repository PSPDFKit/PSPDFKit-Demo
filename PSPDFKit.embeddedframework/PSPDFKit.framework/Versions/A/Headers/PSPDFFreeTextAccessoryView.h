//
//  PSPDFFreeTextAccessoryView.h
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

@class PSPDFFreeTextAccessoryView;

@protocol PSPDFFreeTextAccessoryViewDelegate <NSObject>

- (void)doneButtonPressedOnFreeTextAccessoryView:(PSPDFFreeTextAccessoryView *)inputView;
- (void)inspectorButtonPressedOnFreeTextAccessoryView:(PSPDFFreeTextAccessoryView *)inputView;
- (void)clearButtonPressedOnFreeTextAccessoryView:(PSPDFFreeTextAccessoryView *)inputView;
- (BOOL)freeTextAccessoryViewShouldEnableClearButton:(PSPDFFreeTextAccessoryView *)inputView;

@end

// Notification when someone pressed "Clear".
extern NSString *const PSPDFFreeTextAccessoryViewDidPressClearButtonNotification;

/// Free Text accessory toolbar for faster styling.
@interface PSPDFFreeTextAccessoryView : UIView

/// Designated initializer.
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<PSPDFFreeTextAccessoryViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/// The input accessory delegate.
@property (nonatomic, weak) id<PSPDFFreeTextAccessoryViewDelegate> delegate;

/// Update the toolbar.
- (void)updateToolbar;

@end

@interface PSPDFFreeTextAccessoryView (SubclassingHooks)

// Getters are lazily initialized. Never return nil for these!
@property (nonatomic, strong, readonly) UIBarButtonItem *doneButton;
@property (nonatomic, strong, readonly) UIBarButtonItem *clearButton;
@property (nonatomic, strong, readonly) UIBarButtonItem *inspectorButton;

// Default handlers.
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;
- (IBAction)inspectorButtonPressed:(id)sender;

@end
