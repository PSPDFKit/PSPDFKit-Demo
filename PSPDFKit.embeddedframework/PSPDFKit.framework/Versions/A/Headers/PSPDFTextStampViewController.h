//
//  PSPDFTextStampViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFColorSelectionViewController.h"

@class PSPDFStampAnnotation, PSPDFTextStampViewController;

/// Delegate to be notified on signature actions.
@protocol PSPDFTextStampViewControllerDelegate <NSObject>

@optional

/// Add button has been pressed.
- (void)textStampViewController:(PSPDFTextStampViewController *)stampController didCreateAnnotation:(PSPDFStampAnnotation *)stampAnnotation;

@end

///
/// Allows to create/edit a custom text annotation stamp.
///
@interface PSPDFTextStampViewController : UITableViewController <PSPDFColorSelectionViewControllerDelegate>

/// Initialize controller to create a new stamp.
- (id)init;

/// Initialize controller with a preexisting stamp.
- (id)initWithStampAnnotation:(PSPDFStampAnnotation *)stampAnnotation;

/// Text Stamp controller delegate.
@property (nonatomic, weak) IBOutlet id <PSPDFTextStampViewControllerDelegate> delegate;

/// The stamp annotation.
///
/// If controller isn't initialize with a stamp, a new one will be created.
@property (nonatomic, strong, readonly) PSPDFStampAnnotation *stampAnnotation;

/// The default stamp text if stamp is created.
///
/// Defaults to nil.
@property (nonatomic, copy) NSString *defaultStampText;

@end
