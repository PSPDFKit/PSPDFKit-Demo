//
//  PSPDFSignatureViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFBaseViewController.h"
#import "PSPDFDrawView.h"

@class PSPDFSignatureViewController;

/// Delegegate to be notified on signature actions
@protocol PSPDFSignatureViewControllerDelegate <NSObject>

@optional

/// Cancel button has been pressed.
- (void)signatureViewControllerDidCancel:(PSPDFSignatureViewController *)signatureController;

/// Save/Done button has been pressed.
- (void)signatureViewControllerDidSave:(PSPDFSignatureViewController *)signatureController;


@end

@interface PSPDFSignatureViewController : PSPDFBaseViewController <PSPDFDrawViewDelegate>

/// Designated initializer.
- (id)init;

/// Lines of the drawView.
@property (nonatomic, strong, readonly) NSArray *lines;

/// Signature controller delegate.
@property (nonatomic, weak) id <PSPDFSignatureViewControllerDelegate> delegate;

/// Save additional properties here. This will not be used by the signature controller.
@property (nonatomic, copy) NSDictionary *userInfo;

@end


@interface PSPDFSignatureViewController (SubclassingHooks)

// Internally used drawView.
@property (nonatomic, strong, readonly) PSPDFDrawView *drawView;

@end
