//
//  PSCViewHelper.h
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#pragma mark - Common Metrics

CGFloat PSCToolbarHeight(BOOL isSmall);
CGFloat PSCToolbarHeightForOrientation(UIInterfaceOrientation orientation);

#pragma mark - Animations

CATransition *PSCFadeTransitionWithDuration(CGFloat duration);

#pragma mark - View Introspection

UIView *PSCGetViewInsideView(UIView *view, NSString *classNamePrefix);

#pragma mark - Geometry

CGFloat PSCScaleForSizeWithinSize(CGSize targetSize, CGSize boundsSize);

// Detect if a popover of class `controllerClass` is visible.
BOOL PSCIsControllerClassAndVisible(id c, Class controllerClass);
