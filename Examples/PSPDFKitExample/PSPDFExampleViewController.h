//
//  PSPDFExampleViewController.h
//  PSPDFKitExample
//
//  Copyright 2011-2012 Peter Steinberger. All rights reserved.
//

@class PSPDFMagazine;

/// Customized subclass of PSPDFViewController, adding more HUD buttons.
@interface PSPDFExampleViewController : PSPDFViewController <PSPDFViewControllerDelegate>

/// Referenced magazine; just a cast to .document.
@property (nonatomic, strong, readonly) PSPDFMagazine *magazine;

@end
