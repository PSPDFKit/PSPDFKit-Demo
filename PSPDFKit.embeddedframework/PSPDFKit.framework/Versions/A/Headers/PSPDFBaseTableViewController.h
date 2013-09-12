//
//  PSPDFBaseTableViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"

// This flag will be set to boolean @YES via an associated property during popover resizing.
// Can be used to prevent stray cell animations when the popover animation shows new cells.
extern const char PSPDFTableViewIsResizing;

// Generic table view controller with popover resizing code.
@interface PSPDFBaseTableViewController : UITableViewController

// Will adjust the table view for the status bar. Defaults to NO.
@property (nonatomic, assign) BOOL automaticallyAdjustsTableViewInsets;

/// If enabled, popover size is changed as items are expanded/collapsed.
/// Defaults to NO, but will most likely be set to yes in the subclass.
@property (nonatomic, assign) BOOL automaticallyResizesPopover;

/// If `automaticallyResizesPopover` is enabled, this defines the minimum height of the popover.
/// Defaults to 310.f
@property (nonatomic, assign) CGFloat minimumHeightForAutomaticallyResizingPopover;

/// Save additional properties here. Will not be used by PSPDFKit.
@property (nonatomic, copy) NSDictionary *userInfo;

// Tries to force a popover size update.
- (void)forcePopoverSize;

// Will swap the background to be blurry. Available on iOS7 and later.
- (void)setBlurryBackground;

@end

@interface PSPDFBaseTableViewController (SubclassingHooks)

// By default, popover size will be the tableView size.
// Usually you want to override `requiredPopoverSize` instead.
- (void)updatePopoverSize;

// Returns the required popover size. Override to customize.
- (CGSize)requiredPopoverSize;

@end
