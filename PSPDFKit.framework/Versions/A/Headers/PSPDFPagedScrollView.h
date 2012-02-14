//
//  PSPDFPagedScrollView.h
//  PSPDFKit
//
//  Copyright (c) 2011 Peter Steinberger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFKitGlobal.h"
#import "PSPDFScrollView.h"

@class PSPDFPageViewController;

/// ScrollView used in pageCurl mode. iOS5 only.
@interface PSPDFPagedScrollView : PSPDFScrollView

/// Initializes the PagedScrollView with a pageController.
- (id)initWithPageViewController:(PSPDFPageViewController *)pageController;

/// References the pageController
@property(nonatomic, ps_weak, readonly) PSPDFPageViewController *pageController;

@end
