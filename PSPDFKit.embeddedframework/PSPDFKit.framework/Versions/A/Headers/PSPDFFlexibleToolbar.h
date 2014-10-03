//
//  PSPDFFlexibleToolbar.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

@protocol PSPDFSystemBar;
@class PSPDFFlexibleToolbarDragView;
@class PSPDFFlexibleToolbar;
@class PSPDFFlexibleToolbarCollapsedButton;
@class PSPDFMenuItem;

typedef NS_OPTIONS(NSUInteger, PSPDFFlexibleToolbarPosition) {
    PSPDFFlexibleToolbarPositionNone      = 0,
    PSPDFFlexibleToolbarPositionInTopBar  = 1 << 0,
    PSPDFFlexibleToolbarPositionLeft      = 1 << 1,
    PSPDFFlexibleToolbarPositionRight     = 1 << 2,
    PSPDFFlexibleToolbarPositionsVertical = PSPDFFlexibleToolbarPositionLeft | PSPDFFlexibleToolbarPositionRight,
    PSPDFFlexibleToolbarPositionsAll      = PSPDFFlexibleToolbarPositionInTopBar | PSPDFFlexibleToolbarPositionsVertical
};

typedef NS_ENUM(NSInteger, PSPDFFlexibleToolbarGroupButtonIndicatorPosition) {
    PSPDFFlexibleToolbarGroupButtonIndicatorPositionNone = 0,
    PSPDFFlexibleToolbarGroupButtonIndicatorPositionBottomLeft,
    PSPDFFlexibleToolbarGroupButtonIndicatorPositionBottomRight
};

extern CGFloat const PSPDFFlexibleToolbarHeight;
extern CGFloat const PSPDFFlexibleToolbarHeightPhoneLandscape;
extern CGFloat const PSPDFFlexibleToolbarTopAttachedExtensionHeight;

#define PSPDFFlexibleToolbarGroupIndicatorPositionForToolbarPosition(position) ((position == PSPDFFlexibleToolbarPositionRight) ? PSPDFFlexibleToolbarGroupButtonIndicatorPositionBottomLeft : PSPDFFlexibleToolbarGroupButtonIndicatorPositionBottomRight)

#define PSPDFFlexibleToolbarPositionIsHorizontal(position) ((position) == PSPDFFlexibleToolbarPositionInTopBar)
#define PSPDFFlexibleToolbarPositionIsVertical(position) ((position) == PSPDFFlexibleToolbarPositionLeft || (position) == PSPDFFlexibleToolbarPositionRight)

@protocol PSPDFFlexibleToolbarDelegate <NSObject>

@optional

/// The toolbar container will be displayed (called before `showToolbarAnimated:completion:` is performed).
- (void)flexibleToolbarWillShow:(PSPDFFlexibleToolbar *)toolbar;

/// The toolbar container has been displayed (called after `showToolbarAnimated:completion:` is performed).
- (void)flexibleToolbarDidShow:(PSPDFFlexibleToolbar *)toolbar;

/// The toolbar container will be hidden (called before `hideToolbarAnimated:completion:` is performed).
- (void)flexibleToolbarWillHide:(PSPDFFlexibleToolbar *)toolbar;

/// The toolbar container has ben hidden (called after `hideToolbarAnimated:completion:` is performed).
- (void)flexibleToolbarDidHide:(PSPDFFlexibleToolbar *)toolbar;

/// Called whenever the flexible toolbar changes position in response to a user drag & drop action
- (void)flexibleToolbar:(PSPDFFlexibleToolbar *)toolbar didChangePosition:(PSPDFFlexibleToolbarPosition)position;

@end

/**
 A custom toolbar, that can dragged around the screen and anchored to different positions.

 This class holds an array of `UIButton` objects. For best results use `PSPDFFlexibleToolbarButton` or one of its subclasses.
 PSPDFFlexibleToolbar should be used in combination with a `PSPDFFlexibleToolbarContainer` instance.
 The bar's visual appearance can be customized using UIAppearance compliant properties.

 @see `PSPDFFlexibleToolbarContainer`
 */
@interface PSPDFFlexibleToolbar : UIView

/// A list of valid toolbar positions.
/// Defaults to `PSPDFFlexibleToolbarPositionsAll` on the iPad and `PSPDFFlexibleToolbarPositionsAll` otherwise.
@property (nonatomic, assign) PSPDFFlexibleToolbarPosition supportedToolbarPositions;

/// Current toolbar position (limited to `supportedToolbarPositions`).
@property (nonatomic, assign) PSPDFFlexibleToolbarPosition toolbarPosition;

/// Sets the toolbar position and optionally animates the change (move or fade, depending on whether the orientation changes)
- (void)setToolbarPosition:(PSPDFFlexibleToolbarPosition)toolbarPosition animated:(BOOL)animated;

/// Toolbar delegate. (Can be freely set to any receiver)
@property (nonatomic, weak) id<PSPDFFlexibleToolbarDelegate> toolbarDelegate;

/// Enables or disables toolbar dragging (hides the `dragView` when disabled).
/// Defaults to YES on the iPad and NO otherwise.
@property (nonatomic, assign, getter = isDragEnabled) BOOL dragEnabled;

/// Currently set buttons. Needs to be an array of UIButton instances.
/// For best results use `PSPDFFlexibleToolbarButton` and its subclasses.
/// Use `PSPDFFlexibleToolbarSpacerButton` to add fixed or flexible space to the toolbar.
@property (nonatomic, copy) NSArray *buttons;

/// Sets the buttons and optionally performs a cross-fade animation between the previous and new button set.
- (void)setButtons:(NSArray *)buttons animated:(BOOL)animated;

/// The currently selected button. The selected button is indicated by a selection bezel behind the button.
/// The selected button's tint color gets automatically adjusted to `selectedTintColor` as well.
@property (nonatomic, strong) UIButton *selectedButton;

/// Sets the selection button and optionally fades the selection view.
- (void)setSelectedButton:(UIButton *)button animated:(BOOL)animated;

/// @name Presentation

/// Shows the toolbar (optionally by fading it in).
- (void)showToolbarAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completionBlock;

/// Hides the toolbar (optionally by fading it out).
- (void)hideToolbarAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completionBlock;

/// @name Styling

/// A view placed behind the toolbar items.
/// Defaults to a custom view that mimics the system toolbar / navigation bars design.
@property (nonatomic, strong) UIView *backgroundView;

/// Drag indicator view, positioned on the right or bottom of the toolbar (depending on the toolbar orientation).
/// Drag & drop gesture recognizers (UIPanGestureRecognizer) should be added to this view.
/// Visible only if `dragEnabled` is set to YES.
@property (nonatomic, strong, readonly) PSPDFFlexibleToolbarDragView *dragView;

/// The bar tint color. Gets passed on to the background view (setting its `barTintColor` if implemented,
/// otherwise its backgroundColor).
@property (nonatomic, strong) UIColor *barTintColor UI_APPEARANCE_SELECTOR;

/// The tint color for selected buttons.
/// Defaults to `barTintColor` if available, otherwise an attempt is made to select an appropriate color
/// based on the `backgroundView` appearance.
@property (nonatomic, strong) UIColor *selectedTintColor UI_APPEARANCE_SELECTOR;

/// The selection bezel color.
/// Defaults to self.tintColor.
@property (nonatomic, strong) UIColor *selectedBackgroundColor UI_APPEARANCE_SELECTOR;

/// Toolbar positions that draw a thin border around the toolbar.
/// Defaults to `PSPDFFlexibleToolbarPositionsAll`.
@property (nonatomic, assign) PSPDFFlexibleToolbarPosition borderedToolbarPositions UI_APPEARANCE_SELECTOR;

/// Toolbar positions that draw a faint shadow around the toolbar.
/// Defaults to `PSPDFFlexibleToolbarPositionsVertical`.
@property (nonatomic, assign) PSPDFFlexibleToolbarPosition shadowedToolbarPositions UI_APPEARANCE_SELECTOR;

/// Matches the toolbar appearance to the provided UINavigationBar or UIToolbar.
/// Includes `barTintColor`, `tintColor`, `barStyle` and `translucency`.
/// The `barTintColor` and `tintColor` are only matched if the haven't been already explicitly set (using properties or UIAppearance).
- (void)matchUIBarAppearance:(UIView<PSPDFSystemBar> *)navigationBarOrToolbar;

/// @name Metrics

/// Returns the toolbars native size for the provided position, bound to the `availableSize`.
/// Internally used by the container view to correctly position the toolbar and anchor views during drag & drop.
/// The toolbar height will be increased when docked underneath the status bar by `PSPDFFlexibleToolbarContainer`.
/// @see -[PSPDFToolbarContainer rectForToolbarPosition:]
- (CGSize)preferredSizeFitting:(CGSize)availableSize forToolbarPosition:(PSPDFFlexibleToolbarPosition)position;

/// @name Overflow handling

/// An array of buttons that have been collapsed into `collapsedButton` due to lack of toolbar space.
/// Collapsable buttons need to be `PSPDFFlexibleToolbarButton` with the `collapsible` flag set to yes.
@property (nonatomic, strong, readonly) NSArray *collapsedButtons;

/// Added to the toolbar when toolbar buttons get collapsed due to lack of toolbar space.
/// @see collapsedButtons
/// @see showMenuForCollapsedButtons:fromButton:animated:
@property (nonatomic, strong, readonly) PSPDFFlexibleToolbarCollapsedButton *collapsedButton;

/// @name Menu

/// Shows a menu (UIMenuController) for a specific button.
/// @param menuItems An array of PSPDFMenuItem objects.
/// @param target The target view (most commonly on of the buttons) used to anchor the menu arrow.
/// @param animated Whether to animate the menu presentation or not.
- (void)showMenuWithItems:(NSArray *)menuItems target:(UIView *)target animated:(BOOL)animated;

/// Called when the `collapsedButton` menu action is invoked.
/// The default implementation uses `menuItemForButton:` to convert buttons into menu items
/// and than calls through to `showMenuWithItems:target:animated:`.
- (void)showMenuForCollapsedButtons:(NSArray *)buttons fromButton:(UIButton *)sourceButton animated:(BOOL)animated;

/// Converts buttons into similarly styled menu items
- (PSPDFMenuItem *)menuItemForButton:(UIButton *)button;

@end

/// Toolbar drag & drop indicator view.
@interface PSPDFFlexibleToolbarDragView : UIView

/// Color used for the bar indicators or as the background color in inverted mode.
/// Defaults to `tintColor` in UIKit.
@property (nonatomic, strong) UIColor *barColor;

/// Inverts the bar and background color (can be used to indicate selection).
@property (nonatomic, assign) BOOL inverted;

/// Inverts the bar and background color and optionally fades the transition.
- (void)setInverted:(BOOL)inverted animated:(BOOL)animated;

@end

/// A UIButton subclass that mimic the appearance of plain style UIBarButtonItems.
@interface PSPDFFlexibleToolbarButton : UIButton

/// Designates the button to be collapsible into one item, if toolbar space is limited.
/// Defaults to YES.
@property (nonatomic, assign, getter = isCollapsible) BOOL collapsible;

/// Styles the provided image and sets it as the button image for several button states.
- (void)setImage:(UIImage *)image;

@property (nonatomic, strong) id userInfo;

@end

/// PSPDFFlexibleToolbarButton with a grouping disclosure indicator.
@interface PSPDFFlexibleToolbarGroupButton : PSPDFFlexibleToolbarButton

/// An implicitly added gesture long press recognizer (can be used to display the group contents).
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressRecognizer;

/// The location of the disclosure indicator on the button.
@property (nonatomic, assign) PSPDFFlexibleToolbarGroupButtonIndicatorPosition groupIndicatorPosition;

@end

/// Special `PSPDFFlexibleToolbarGroupButton` used for the collapsed button item.
@interface PSPDFFlexibleToolbarCollapsedButton : PSPDFFlexibleToolbarGroupButton

/// A button whose appearance is mimicked.
@property (nonatomic, strong, readonly) UIButton *mimickedButton;

@end

/// Buttons that can be used as spaces for the flexible toolbar
/// (similar to UIBarButtonSystemItemFlexibleSpace and UIBarButtonSystemItemFixedSpace).
@interface PSPDFFlexibleToolbarSpacerButton : UIButton

/// If YES, the actual button space will be computed dynamically by counting all flexible button instances
/// and dividing the remaining available toolbar space with that number. Otherwise the width will be
/// taken from the `width` property.
@property (nonatomic, assign, getter = isFlexible) BOOL flexible;

/// The fixed with value.
@property (nonatomic, assign) CGFloat width;

@end
