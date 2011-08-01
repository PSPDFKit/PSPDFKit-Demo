//
//  PSPDFExampleViewController.h
//  PSPDFKitExample
//
//  Created by Peter Steinberger on 7/22/11.
//  Copyright 2011 Peter Steinberger. All rights reserved.
//

@class PSPDFMagazine;

@interface PSPDFExampleViewController : PSPDFViewController <PSPDFViewControllerDelegate>

@property (nonatomic, retain, readonly) PSPDFMagazine *magazine;

@end
