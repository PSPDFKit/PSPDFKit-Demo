//
//  PSPDFNavigationAppearanceSnapshot.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

/// Saves the current appearance state of the UINavigationController.
/// Sadly, Apple doesn't give us any system for this.
@interface PSPDFNavigationAppearanceSnapshot : NSObject

/// Create a new snapshot.
- (id)initForNavigationController:(UINavigationController *)navigationController;

/// Just restores the status bar
- (void)restoreStatusBarStateAnimated:(BOOL)animated;
- (void)restoreStatusBarStateWithAnimation:(UIStatusBarAnimation)animation;

/// Be smart about animations.
- (BOOL)shouldAnimateAgainstNavigationController:(UINavigationController *)navigationController;

/// Apply the previously captured state.
/// Does NOT automatically call [self restoreStatusBarStateAnimated:animated].
- (void)restoreForNavigationController:(UINavigationController *)navigationController animated:(BOOL)animated;

@end
