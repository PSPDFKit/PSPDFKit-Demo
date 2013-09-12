//
//  PSPDFSignatureSelectorViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBaseTableViewController.h"
#import "PSPDFStyleable.h"

@class PSPDFSignatureSelectorViewController, PSPDFInkAnnotation;

/// Delegate to be notified when the PSPDFSignatureSelectorViewController has a valid selection.
@protocol PSPDFSignatureSelectorViewControllerDelegate <PSPDFOverridable>

/// A signature has been selected.
- (void)signatureSelectorViewController:(PSPDFSignatureSelectorViewController *)signatureSelectorController didSelectSignature:(PSPDFInkAnnotation *)signature;

/// The 'add' button has been pressed.
- (void)signatureSelectorViewControllerWillCreateNewSignature:(PSPDFSignatureSelectorViewController *)signatureSelectorController;

@end

/// Shows a list of signatures to select one.
/// Will show up in landscape on iOS6 (preferredInterfaceOrientationForPresentation)
@interface PSPDFSignatureSelectorViewController : PSPDFBaseTableViewController <PSPDFStyleable>

/// Designated initializer.
- (id)initWithSignatures:(NSArray *)signatures;

/// Signatures that are being displayed.
@property (nonatomic, copy, readonly) NSArray *signatures;

/// Delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFSignatureSelectorViewControllerDelegate> delegate;

@end
