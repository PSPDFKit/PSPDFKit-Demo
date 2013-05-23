//
//  PSPDFContentScrollView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFScrollView.h"
#import "PSPDFTransitionProtocol.h"

/// ScrollView used in pageCurl mode.
@interface PSPDFContentScrollView : PSPDFScrollView

/// Initializes the PagedScrollView with a viewController.
- (id)initWithTransitionViewController:(UIViewController <PSPDFTransitionProtocol> *)viewController;

/// References the pageController
// atomic, might be accessed from a background thread during deallocation.
@property (nonatomic, strong, readonly) UIViewController <PSPDFTransitionProtocol> *contentController;

@end
