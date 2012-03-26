//
//  PSPDFPagedScrollView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
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
// atomic, might be accessed from a background thread during deallocation
@property(strong, readonly) PSPDFPageViewController *pageController;

@end
