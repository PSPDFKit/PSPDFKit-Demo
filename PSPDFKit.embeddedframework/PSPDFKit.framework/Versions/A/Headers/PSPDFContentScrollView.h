//
//  PSPDFContentScrollView.h
//  PSPDFKit
//
//  Copyright (c) 2011-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFScrollView.h"
#import "PSPDFTransitionProtocol.h"

/// The content scroll view, used for `PSPDFPageTransitionCurl` and `PSPDFPageTransitionScrollContinuous`.
@interface PSPDFContentScrollView : PSPDFScrollView

/// Initializes the `PSPDFContentScrollView` with a `viewController`.
- (instancetype)initWithTransitionViewController:(UIViewController <PSPDFTransitionProtocol> *)viewController;

/// References the pageController
// atomic, might be accessed from a background thread during deallocation.
@property (nonatomic, strong, readonly) UIViewController <PSPDFTransitionProtocol> *contentController;

@end
