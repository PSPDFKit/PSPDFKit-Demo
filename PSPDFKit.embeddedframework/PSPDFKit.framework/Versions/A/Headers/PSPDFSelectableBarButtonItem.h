//
//  PSPDFSelectableBarButtonItem.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFBarButtonItem.h"

/**
 PSPDFBarButtonItem subclass with selection support.
 
 Assumes that an image is provided via the `image` method.
 Selection are iOS 7+ only. The class will gracefully fall back to the default 
 `PSPDFBarButtonItem` behavior on previous system versions.
 */
@interface PSPDFSelectableBarButtonItem : PSPDFBarButtonItem

/// @name Selection

/// Toggles selection on or off without animation.
/// @see `setSelected:animated:`
@property (nonatomic, assign, getter=isSelected) BOOL selected;

/// Shows or hides the selection indicator.
/// The image tint color is changed to `selectedTintColor`, and a bezel with `selectedBackgroundColor` is shown.
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;


/// @name Styling

/// Selected image tint color.
/// Defaults to the `barTintColor` of PSPDFViewController's navigation bar, if available.
@property (nonatomic, strong) UIColor *selectedTintColor;

/// Selection indicator bezel color.
/// Defaults to `tintColor`.
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

@end
