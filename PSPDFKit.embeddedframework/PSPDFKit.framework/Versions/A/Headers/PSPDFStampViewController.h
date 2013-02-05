//
//  PSPDFStampViewController.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFBaseViewController.h"
#import "PSTCollectionView.h"
#import "PSPDFTextStampViewController.h"

@class PSPDFStampViewController, PSPDFStampAnnotation;

/// Delegate to be notified on signature actions.
@protocol PSPDFStampViewControllerDelegate <NSObject>

@optional

/// Cancel button has been pressed.
///
/// @warning The popover can also disappear without any button pressed, in that case the delegate is not called.
- (void)stampViewControllerDidCancel:(PSPDFStampViewController *)stampController;

/// Save/Done button has been pressed.
- (void)stampViewController:(PSPDFStampViewController *)stampController didSelectAnnotation:(PSPDFStampAnnotation *)stampAnnotation;

@end

/// Allows adding signatures or drawings as ink annotations.
@interface PSPDFStampViewController : PSPDFBaseViewController <PSPDFTextStampViewControllerDelegate, PSUICollectionViewDelegate, PSUICollectionViewDataSource>

/// Return default available set of stamp annotations.
+ (NSArray *)defaultStampAnnotations;

/// Designated initializer.
- (id)init;

/// Available stamp types. Set before showing controller.
@property (nonatomic, copy) NSArray *stamps;

/// Stamp controller delegate.
@property (nonatomic, weak) IBOutlet id<PSPDFStampViewControllerDelegate> delegate;

/// Save additional properties here. This will not be used by the signature controller.
@property (nonatomic, copy) NSDictionary *userInfo;

@end


@interface PSPDFStampViewController (SubclassingHooks)

// To make custom buttons.
- (void)cancel:(id)sender;

// Internally used grid view
@property (nonatomic, strong) PSUICollectionView *gridView;

@end


/// Stamp Cell.
@interface PSPDFStampCell : PSUICollectionViewCell

@property (nonatomic, strong) PSPDFStampAnnotation *annotation;

@end
