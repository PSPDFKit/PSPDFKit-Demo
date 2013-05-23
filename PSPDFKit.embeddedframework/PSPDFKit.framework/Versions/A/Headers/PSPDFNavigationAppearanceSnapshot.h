//
//  PSPDFNavigationAppearanceSnapshot.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
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
