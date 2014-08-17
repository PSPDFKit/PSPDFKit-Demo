//
//  PSCViewHelper.m
//  PSPDFCatalog
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <tgmath.h>
#import <mach-o/dyld.h>
#import "PSCViewHelper.h"

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Common Metrics

CGFloat PSCToolbarHeight(BOOL isSmall) { return isSmall && !PSCIsIPad() ? 33.f : 44.f; }

CGFloat PSCToolbarHeightForOrientation(UIInterfaceOrientation orientation) {
    return PSCToolbarHeight(UIInterfaceOrientationIsLandscape(orientation));
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Animations

#if TARGET_IPHONE_SIMULATOR
UIKIT_EXTERN CGFloat UIAnimationDragCoefficient(void); // UIKit private drag coeffient.
#endif

static CGFloat PSCSimulatorAnimationDragCoefficient(void) {
#if TARGET_IPHONE_SIMULATOR
    return UIAnimationDragCoefficient();
#else
    return 1.0;
#endif
}

CATransition *PSCFadeTransitionWithDuration(CGFloat duration) {
    CATransition *transition = [CATransition animation];
    transition.duration = duration * PSCSimulatorAnimationDragCoefficient();
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    return transition;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - View Introspection

UIView *PSCGetViewInsideView(UIView *view, NSString *classNamePrefix) {
    if (!view || classNamePrefix.length == 0) return nil;

    UIView *theView = nil;
    for (__unsafe_unretained UIView *subview in view.subviews) {
        if ([NSStringFromClass(subview.class) hasPrefix:classNamePrefix] ||
            [NSStringFromClass(subview.superclass) hasPrefix:classNamePrefix]) {
            return subview;
        }else {
            if ((theView = PSCGetViewInsideView(subview, classNamePrefix))) break;
        }
    }
    return theView;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Geometry

CGFloat PSCScaleForSizeWithinSize(CGSize targetSize, CGSize boundsSize) {
    CGFloat xScale = boundsSize.width / targetSize.width;
    CGFloat yScale = boundsSize.height / targetSize.height;
    CGFloat minScale = __tg_fmin(xScale, yScale);
    return minScale > 1.f ? 1.f : minScale;
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Popover

static BOOL PSCIsControllerClassInPopoverAndVisible(UIPopoverController *popoverController, Class controllerClass) {
    UIViewController *contentController = popoverController.contentViewController;
    if ([contentController isKindOfClass:UINavigationController.class]) {
        contentController = [(UINavigationController *)contentController topViewController];
    }

    BOOL classInPopover = [contentController isKindOfClass:controllerClass];
    return classInPopover && popoverController.isPopoverVisible;
}

BOOL PSCIsControllerClassAndVisible(id c, Class controllerClass) {
    return [c isKindOfClass:controllerClass] ||
    ([c isKindOfClass:UINavigationController.class] && [((UINavigationController *)c).visibleViewController isKindOfClass:controllerClass]) ||
    ([c isKindOfClass:UIPopoverController.class] && PSCIsControllerClassInPopoverAndVisible(c, controllerClass));
}

