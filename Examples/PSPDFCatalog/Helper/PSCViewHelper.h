//
//  PSCViewHelper.h
//  PSPDFCatalog
//
//  Copyright (c) 2013 PSPDFKit GmbH. All rights reserved.
//
//  The PSPDFKit Sample applications are licensed with a modified BSD license.
//  Please see License for details. This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - Common Metrics

CGFloat PSCToolbarHeight(BOOL isSmall);
CGFloat PSCToolbarHeightForOrientation(UIInterfaceOrientation orientation);

#pragma mark - Animations

CATransition *PSCFadeTransitionWithDuration(CGFloat duration);
CATransition *PSCFadeTransition(void);

#pragma mark - View Introspection

UIView *PSCGetViewInsideView(UIView *view, NSString *classNamePrefix);

void PSCFixNavigationBarForNavigationControllerAnimated(UINavigationController *navController, BOOL animated);
