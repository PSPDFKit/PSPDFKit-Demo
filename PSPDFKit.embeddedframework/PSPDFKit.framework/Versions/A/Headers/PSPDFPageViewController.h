//
//  PSPDFPageViewController.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PSPDFTransitionProtocol.h"

/// Implements the PageCurl-style famously presented in iBooks.
/// @note Due to the nature of the animation, it doesn't look well with non-equal sized documents.
@interface PSPDFPageViewController : UIPageViewController <PSPDFTransitionProtocol, UIPageViewControllerDelegate, UIPageViewControllerDataSource>

/// Initializes the page view controller with the configuration data source.
- (instancetype)initWithPresentationContext:(id <PSPDFPresentationContext>)presentationContext NS_DESIGNATED_INITIALIZER;

/// Associated `PSPDFPresentationContext`.
@property (nonatomic, weak, readonly) id<PSPDFPresentationContext> presentationContext;

/// If set to YES, the background of the `UIViewController` is used. Else you may get some animation artifacts. Defaults to NO.
@property (nonatomic, assign) BOOL useSolidBackground;

/// Clips the page to its boundaries, not showing a page curl on empty background. Defaults to YES.
/// Usually you want this, unless your document is variable sized.
@property (nonatomic, assign) BOOL clipToPageBoundaries;

@end
