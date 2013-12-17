//
//  PSCViewHelper.m
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import "PSCViewHelper.h"
#import <tgmath.h>
#import <mach-o/dyld.h>

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Common Metrics

CGFloat PSCToolbarHeight(BOOL isSmall) { return isSmall && !PSCIsIPad() ? 33.f : 44.f; }

CGFloat PSCToolbarHeightForOrientation(UIInterfaceOrientation orientation) {
    return PSCToolbarHeight(UIInterfaceOrientationIsLandscape(orientation));
}

///////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Animations

static CGFloat PSCSimulatorAnimationDragCoefficient(void) {
    static CGFloat (*UIAnimationDragCoefficient)(void) = NULL;
#if TARGET_IPHONE_SIMULATOR
#import <dlfcn.h>
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIAnimationDragCoefficient = (CGFloat (*)(void))dlsym(RTLD_DEFAULT, "UIAnimationDragCoefficient");
    });
#endif
    return UIAnimationDragCoefficient ? UIAnimationDragCoefficient() : 1.f;
}

CATransition *PSCFadeTransitionWithDuration(CGFloat duration) {
    CATransition *transition = [CATransition animation];
    transition.duration = duration * PSCSimulatorAnimationDragCoefficient();
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    return transition;
}

CATransition *PSCFadeTransition(void) {
    return PSCFadeTransitionWithDuration(0.25f);
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

void PSCFixNavigationBarForNavigationControllerAnimated(UINavigationController *navController, BOOL animated) {
    // This will trigger _updateBarsForCurrentInterfaceOrientation as well, but will also call this in the topViewController.
    [navController willAnimateRotationToInterfaceOrientation:navController.interfaceOrientation duration:0.f];
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
#pragma mark - UIKit Detection

// https://gist.github.com/steipete/6526860
#define UIKitVersionNumber_iOS_7_0 0xB57
BOOL PSCIsUIKitFlatMode(void) {
    static BOOL isUIKitFlatMode = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // We get the modern UIKit if system is running >= iOS 7 and we were linked with >= SDK 7.
        if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
            isUIKitFlatMode = (NSVersionOfLinkTimeLibrary("UIKit") >> 16) >= UIKitVersionNumber_iOS_7_0;
        }
    });
    return isUIKitFlatMode;
}
