//
//  PSPDFPagedScrollView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFScrollView.h"

@class PSPDFTransitionViewController;

/// ScrollView used in pageCurl mode. iOS5 only.
@interface PSPDFPagedScrollView : PSPDFScrollView

/// Initializes the PagedScrollView with a transitionController.
- (id)initWithTransitionViewController:(PSPDFTransitionViewController *)pageController;

/// References the pageController
// atomic, might be accessed from a background thread during deallocation
@property(strong, readonly) PSPDFTransitionViewController *transitionController;

@end
