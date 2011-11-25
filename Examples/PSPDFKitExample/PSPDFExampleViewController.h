//
//  PSPDFExampleViewController.h
//  PSPDFKitExample
//
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFMagazine;

@interface PSPDFExampleViewController : PSPDFViewController <PSPDFViewControllerDelegate>

@property (nonatomic, strong, readonly) PSPDFMagazine *magazine;

@end
