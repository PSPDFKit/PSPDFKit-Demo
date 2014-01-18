//
//  PSPDFSignatureSelectorViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseTableViewController.h"
#import "PSPDFStyleable.h"
#import "PSPDFStatefulTableViewController.h"

@class PSPDFSignatureSelectorViewController, PSPDFInkAnnotation;

/// Delegate to be notified when the `PSPDFSignatureSelectorViewController` has a valid selection.
@protocol PSPDFSignatureSelectorViewControllerDelegate <PSPDFOverridable>

/// A signature has been selected.
- (void)signatureSelectorViewController:(PSPDFSignatureSelectorViewController *)signatureSelectorController didSelectSignature:(PSPDFInkAnnotation *)signature;

/// The 'add' button has been pressed.
- (void)signatureSelectorViewControllerWillCreateNewSignature:(PSPDFSignatureSelectorViewController *)signatureSelectorController;

@end

/// Shows a list of signatures to select one.
/// Will show up in landscape on iOS6 via `preferredInterfaceOrientationForPresentation`.
@interface PSPDFSignatureSelectorViewController : PSPDFStatefulTableViewController <PSPDFStyleable>

/// Designated initializer.
- (id)initWithSignatures:(NSArray *)signatures;

/// Signatures that are being displayed.
@property (nonatomic, copy, readonly) NSArray *signatures;

/// Signature Selector Delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFSignatureSelectorViewControllerDelegate> delegate;

@end

@interface PSPDFSignatureSelectorViewController (SubclassingHooks)

// Button that will allow adding a new signature.
// @note The toolbar will be set up in `viewWillAppear:`.
@property (nonatomic, strong, readonly) UIBarButtonItem *addSignatureButtonItem;

// Button that will close the view controller. (displayed on iPhone only, will not hide a popover)
@property (nonatomic, strong, readonly) UIBarButtonItem *doneButtonItem;

// Actions
- (void)doneAction:(id)sender;
- (void)addSignatureAction:(id)sender;

@end
