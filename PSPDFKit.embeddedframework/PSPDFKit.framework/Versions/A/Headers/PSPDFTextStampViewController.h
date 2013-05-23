//
//  PSPDFTextStampViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFColorSelectionViewController.h"
#import "PSPDFStaticTableViewController.h"

@class PSPDFStampAnnotation, PSPDFTextStampViewController;

/// Delegate to be notified on signature actions.
@protocol PSPDFTextStampViewControllerDelegate <NSObject>

@optional

/// Add button has been pressed.
- (void)textStampViewController:(PSPDFTextStampViewController *)stampController didCreateAnnotation:(PSPDFStampAnnotation *)stampAnnotation;

@end

/// Allows to create/edit a custom text annotation stamp.
@interface PSPDFTextStampViewController : PSPDFStaticTableViewController <PSPDFColorSelectionViewControllerDelegate, UITextFieldDelegate>

/// Initialize controller to create a new stamp.
- (id)init;

/// Initialize controller with a preexisting stamp.
- (id)initWithStampAnnotation:(PSPDFStampAnnotation *)stampAnnotation;

/// Text Stamp controller delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFTextStampViewControllerDelegate> delegate;

/// The stamp annotation.
///
/// If controller isn't initialize with a stamp, a new one will be created.
@property (nonatomic, strong, readonly) PSPDFStampAnnotation *stampAnnotation;

/// The default stamp text if stamp is created. Defaults to nil.
@property (nonatomic, copy) NSString *defaultStampText;

@end
