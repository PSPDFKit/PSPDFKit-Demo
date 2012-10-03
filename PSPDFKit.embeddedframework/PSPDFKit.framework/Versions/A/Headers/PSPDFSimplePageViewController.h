//
//  PSPDFSimplePageViewController.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@interface PSPDFSimplePageViewController : UIViewController 

- (id)initWithViewControllers:(NSArray *)viewControllers;
- (IBAction)changePage:(id)sender;

@end
