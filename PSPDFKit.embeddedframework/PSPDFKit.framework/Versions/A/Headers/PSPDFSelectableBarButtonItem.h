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
#import "PSPDFFlexibleToolbarContainer.h"

/**
 `PSPDFBarButtonItem `subclass with selection support.
 
 Assumes that an image is provided via the `image` method.
 Selection are iOS 7+ only. The class will gracefully fall back to the default 
 `PSPDFBarButtonItem` behavior on previous system versions.
 
 You can customize the `PSPDFSelectableBarButtonItem` by configuring it's customView
 (a `PSPDFSelectableBarButtonItemView` instance). The `customView` will be nil on iOS < iOS 7.
 */
@interface PSPDFSelectableBarButtonItem : PSPDFBarButtonItem

/// @name Selection

/// Toggles selection on or off without animation.
/// @see `setSelected:animated:`
@property (nonatomic, assign, getter=isSelected) BOOL selected;

/// Shows or hides the selection indicator.
/// The image tint color is changed to `selectedTintColor`, and a bezel with `selectedBackgroundColor` is shown.
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end

@interface PSPDFSelectableBarButtonItem (SubclassingHooks)

/// Returns `UIToolbar` or `UINavigationBar`.
- (UIView<PSPDFSystemBar> *)targetToolbar;

@end

/**
 Use this class to configure the `PSPDFSelectableBarButtonItem` appearance.
 
 The recommended way to set the `PSPDFSelectableBarButtonItemView` `tintColor` is by setting
 the `tintColor` property on the parent `UINavigationBar` / `UIToolbar`. This will enable you to
 quickly set the same tint color for all your `UIBarButtonItem`s.
 
 You can also customize `PSPDFSelectableBarButtonItemView`'s tintColor
 directly or via `UIViewAppearance` to achieve a different look for `PSPDFSelectableBarButtonItem`s.
 */
@interface PSPDFSelectableBarButtonItemView : UIView

/// @name Styling

/// Selected image tint color.
/// Defaults to the `barTintColor` of the containing `UIToolbar` or `UINavigationBar, if available, otherwise white is used.
@property (nonatomic, strong) UIColor *selectedTintColor UI_APPEARANCE_SELECTOR;

/// Selection indicator bezel color.
/// Defaults to `tintColor` (matches `tintColor` when set to nil).
@property (nonatomic, strong) UIColor *selectedBackgroundColor UI_APPEARANCE_SELECTOR;

@end
