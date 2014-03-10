//
//  PSCViewHelper.h
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

@import Foundation;
@import UIKit;
@import QuartzCore.QuartzCore;

#pragma mark - Common Metrics

CGFloat PSCToolbarHeight(BOOL isSmall);
CGFloat PSCToolbarHeightForOrientation(UIInterfaceOrientation orientation);

#pragma mark - Animations

CATransition *PSCFadeTransitionWithDuration(CGFloat duration);
CATransition *PSCFadeTransition(void);

#pragma mark - View Introspection

UIView *PSCGetViewInsideView(UIView *view, NSString *classNamePrefix);

void PSCFixNavigationBarForNavigationControllerAnimated(UINavigationController *navController, BOOL animated);

#pragma mark - Geometry

CGFloat PSCScaleForSizeWithinSize(CGSize targetSize, CGSize boundsSize);

// Detect modern UIKit
BOOL PSCIsUIKitFlatMode(void);

// Detect if a popover of class `controllerClass` is visible.
BOOL PSCIsControllerClassAndVisible(id c, Class controllerClass);
