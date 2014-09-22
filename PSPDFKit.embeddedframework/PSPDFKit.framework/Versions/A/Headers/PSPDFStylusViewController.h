//
//  PSPDFStylusViewController.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFStaticTableViewController.h"

@class PSPDFStylusViewController;

@protocol PSPDFStylusViewControllerDelegate <NSObject>

/// The driver class has been changed.
- (void)stylusViewControllerDidUpdateSelectedType:(PSPDFStylusViewController *)stylusViewController;

/// The settings button has been tapped.
- (void)stylusViewControllerDidTapSettingsButton:(PSPDFStylusViewController *)stylusViewController;

@end

/// Allows stylus management and type selection.
@interface PSPDFStylusViewController : PSPDFStaticTableViewController

/// Designated initializer.
- (instancetype)initWithDriverClasses:(NSArray *)driverClasses NS_DESIGNATED_INITIALIZER;

/// The currently selected driver class.
@property (nonatomic, strong) Class selectedDriverClass;

/// The controller delegate.
@property (nonatomic, weak) id<PSPDFStylusViewControllerDelegate> delegate;

@end
