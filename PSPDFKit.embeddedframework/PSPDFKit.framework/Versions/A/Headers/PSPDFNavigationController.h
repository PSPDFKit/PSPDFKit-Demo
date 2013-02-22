//
//  PSPDFNavigationController.h
//  PSPDFKit
//
//  Copyright (c) 2013 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>

///
/// Simple subclass that forwards following iOS6 rotation methods to the top view controller:
/// shouldAutorotate, supportedInterfaceOrientations, preferredInterfaceOrientationForPresentation.
///
@interface PSPDFNavigationController : UINavigationController

@end
