//
//  PSPDFPagedScrollView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFScrollView.h"
#import "PSPDFTransitionProtocol.h"

/// ScrollView used in pageCurl mode. iOS5 only.
@interface PSPDFPagedScrollView : PSPDFScrollView

/// Initializes the PagedScrollView with a viewController.
- (id)initWithTransitionViewController:(UIViewController<PSPDFTransitionProtocol> *)viewController;

/// References the pageController
// atomic, might be accessed from a background thread during deallocation
@property(strong, readonly) UIViewController<PSPDFTransitionProtocol> *contentController;

@end
