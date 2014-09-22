//
//  PSPDFPopOutMenu.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

typedef NS_ENUM(NSUInteger, PSPDFPopOutMenuExpansionDirection) {
    PSPDFPopOutMenuExpansionDirectionUp = 0,
    PSPDFPopOutMenuExpansionDirectionDown,
    PSPDFPopOutMenuExpansionDirectionLeft,
    PSPDFPopOutMenuExpansionDirectionRight
};

/// A popup menu holding several equally sized views.
/// The view bounds should cover the entire touchable area
/// (usually matching the superview bounds).
@interface PSPDFPopOutMenu : UIView

/// Designates the position of the selected item inside the menu bounds.
@property (nonatomic, assign) CGRect anchorFrame;

/// An array of UIView (UIButton) items to be displayed in the menu.
@property (nonatomic, copy) NSArray *items;

/// The currently selected item. Based on `selectedItemIndex`.
@property (nonatomic, strong) UIView *selectedItem;

/// The currently selected item index. This element will be displayed when the menu is collapsed.
@property (nonatomic, assign) NSUInteger selectedItemIndex;

/// The current menu state.
@property (nonatomic, assign, getter=isExpanded) BOOL expanded;

/// Sets the current state, optionally animating the change.
- (void)setExpanded:(BOOL)expanded animated:(BOOL)animated;

/// Toggles between the expanded and collapsed state.
- (void)toggleAnimated:(BOOL)animated;

/// The menu expansion direction. Defaults to PSPDFPopOutMenuExpansionDirectionUp.
@property (nonatomic, assign) PSPDFPopOutMenuExpansionDirection expansionDirection;

/// The padding between expanded menu items.
@property (nonatomic, assign) CGFloat itemPadding;

@end
