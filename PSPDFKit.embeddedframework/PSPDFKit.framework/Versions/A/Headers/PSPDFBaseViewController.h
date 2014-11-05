//
//  PSPDFBaseViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFMacros.h"

@interface PSPDFBaseViewController : UIViewController
@end

@interface PSPDFBaseViewController (SubclassingHooks)

// Called when the font system base size is changed.
- (void)contentSizeDidChange NS_REQUIRES_SUPER;

@end

@interface PSPDFBaseViewController (SubclassingWarnings)

// PSPDFKit overrides all kind of event hooks for UIViewController.
// You should always call super on those, even if you're just using UIViewController.
- (void)viewWillAppear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewDidAppear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewWillDisappear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewDidDisappear:(BOOL)animated NS_REQUIRES_SUPER;
- (void)viewWillLayoutSubviews NS_REQUIRES_SUPER;
- (void)viewDidLayoutSubviews NS_REQUIRES_SUPER;

- (void)didReceiveMemoryWarning NS_REQUIRES_SUPER;

// Deprecated methods
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration NS_REQUIRES_SUPER;
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration NS_REQUIRES_SUPER;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation NS_REQUIRES_SUPER;

@end

PSPDFKIT_EXTERN_C_BEGIN

// Checks that the `requested` interface orientation is supported by controller and application.
// Pass in the controller's supportedInterfaceOrientations as `supported`.
// Returns the current interface orientation if the check fails.
UIInterfaceOrientation PSPDFSafePreferredInterfaceOrientation(UIInterfaceOrientation requested, NSUInteger supported);

PSPDFKIT_EXTERN_C_END
