//
//  PSPDFPageView+AnnotationMenu.h
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFPageView.h"

@class PSPDFSignatureFormElement;

@interface PSPDFPageView (AnnotationMenu) <PSPDFSignatureViewControllerDelegate, PSPDFSignatureSelectorViewControllerDelegate, PSPDFAnnotationStyleViewControllerDelegate, PSPDFColorSelectionViewControllerDelegate, PSPDFNoteAnnotationViewControllerDelegate, PSPDFFontSelectorViewControllerDelegate, PSPDFFontStyleViewControllerDelegate>

/// Returns available `PSPDFMenuItem's` for the current annotation.
/// The better way to extend this is to use the `shouldShowMenuItems:*` delegates.
- (NSArray *)menuItemsForAnnotations:(NSArray *)annotations;

/// Menu for new annotations (can be disabled in `PSPDFViewController`)
- (NSArray *)menuItemsForNewAnnotationAtPoint:(CGPoint)point;

/// Returns available `PSPDFMenuItem's` to change the color.
/// The better way to extend this is to use the shouldShowMenuItems:* delegates.
- (NSArray *)colorMenuItemsForAnnotation:(PSPDFAnnotation *)annotation;

/// Returns available `PSPDFMenuItem's` to change the fill color (only applies to certain annotations)
- (NSArray *)fillColorMenuItemsForAnnotation:(PSPDFAnnotation *)annotation;

/// Returns the opacity menu item
- (PSPDFMenuItem *)opacityMenuItemForAnnotation:(PSPDFAnnotation *)annotation withColor:(UIColor *)color;

/// Called when a annotation was found ad the tapped location.
/// This will usually call `menuItemsForAnnotation:` to show an `UIMenuController`, except for `PSPDFAnnotationTypeNote` which is handled differently on iPad. (`showNoteControllerForAnnotation`)
/// @note The better way to extend this is to use the `shouldShowMenuItems:*` delegates.
- (void)showMenuForAnnotations:(NSArray *)annotations edgeInsets:(UIEdgeInsets)edgeInsets animated:(BOOL)animated;

/// Shows a popover/modal controller to edit a `PSPDFAnnotation`.
- (PSPDFNoteAnnotationViewController *)showNoteControllerForAnnotation:(PSPDFAnnotation *)annotation showKeyboard:(BOOL)showKeyboard animated:(BOOL)animated;

/// Shows the font picker.
- (void)showFontPickerForAnnotation:(PSPDFFreeTextAnnotation *)annotation animated:(BOOL)animated;

/// Shows the color picker.
- (void)showColorPickerForAnnotation:(PSPDFAnnotation *)annotation animated:(BOOL)animated;

/// Show the signature controller.
- (void)showSignatureControllerAtRect:(CGRect)rect withTitle:(NSString *)title shouldSaveSignature:(BOOL)shouldSaveSignature animated:(BOOL)animated;

/// Font sizes for the free text annotation menu. Defaults to `@[@10, @12, @14, @18, @22, @26, @30, @36, @48, @64]`
- (NSArray *)availableFontSizes;

/// Line width options (ink, border). Defaults to `@[@1, @3, @6, @9, @12, @16, @25, @40]`
- (NSArray *)availableLineWidths;

/// Returns the passthrough views for the popover controllers (e.g. color picker).
/// By default this is fairly aggressive and returns the `pdfController`/`navController`. If you dislike this behavior return nil to enforce the rule first touch after popover = no reaction. However the passthroughViews allow a faster editing of annotations.
- (NSArray *)passthroughViewsForPopoverController;

@end

@interface PSPDFPageView (AnnotationMenuSubclassingHooks)

// Show signature menu.
- (void)showNewSignatureMenuAtRect:(CGRect)rect animated:(BOOL)animated;

// Show digital signature menu.
- (BOOL)showDigitalSignatureMenuForSignatureField:(PSPDFSignatureFormElement *)signatureField animated:(BOOL)animated;

// Show image menu.
- (void)showNewImageMenuAtPoint:(CGPoint)point animated:(BOOL)animated;

// Show new sound overlay.
- (void)addNewSoundAnnotationAtPoint:(CGPoint)point animated:(BOOL)animated;

// Returns the default color options for the specified annotation type.
// The array consists of arrays with NSString, UIColor pairs.
- (NSArray *)defaultColorOptionsForAnnotationType:(PSPDFAnnotationType)annotationType;

// Controls if the annotation inspector is used or manipulation via `UIMenuController`.
- (BOOL)useAnnotationInspectorForAnnotations:(NSArray *)annotations;

// Used to prepare the `UIMenuController`-based color menu.
- (void)selectColorForAnnotation:(PSPDFAnnotation *)annotation isFillColor:(BOOL)isFillColor;

// By default, the highlight menu on iPad and iPhone is different, since on iPad there's more screen real estate - thus we pack the menu options into a "Style..." submenu on iPhone. Override this to customize the behavior. Returns `!PSPDFIsIPad();` by default.
- (BOOL)shouldMoveStyleMenuEntriesIntoSubmenu;

// Will create and show the action sheet on long-press above a `PSPDFLinkAnnotation`.
// Return nil if you don't show the `actionSheet`, or return the object you're showing. (`UIView` or a `UIViewController` subclass)
- (id)showLinkPreviewActionSheetForAnnotation:(PSPDFLinkAnnotation *)annotation fromRect:(CGRect)viewRect animated:(BOOL)animated;

// Show menu if annotation/text is selected.
- (void)showMenuIfSelectedAnimated:(BOOL)animated;

@end

// Text Menu Items
extern NSString *const PSPDFTextMenuCopy;
extern NSString *const PSPDFTextMenuDefine;
extern NSString *const PSPDFTextMenuSearch;
extern NSString *const PSPDFTextMenuWikipedia;
extern NSString *const PSPDFTextMenuCreateLink;
extern NSString *const PSPDFTextMenuSpeak;
extern NSString *const PSPDFTextMenuPause;
// Text menu also uses PSPDFAnnotationMenu[Highlight|Underline|Strikeout|Squiggle].

// General
// Annotation types are used from PSPDFAnnotationString* defines
extern NSString *const PSPDFAnnotationMenuGroup;
extern NSString *const PSPDFAnnotationMenuUngroup;
extern NSString *const PSPDFAnnotationMenuSave;
extern NSString *const PSPDFAnnotationMenuRemove;
extern NSString *const PSPDFAnnotationMenuCopy;
extern NSString *const PSPDFAnnotationMenuPaste;
extern NSString *const PSPDFAnnotationMenuMerge;
extern NSString *const PSPDFAnnotationMenuPreviewFile; // File annotations

// Annotation Style
extern NSString *const PSPDFAnnotationMenuInspector;
extern NSString *const PSPDFAnnotationMenuStyle;       // Highlight annotations on iPhone

// Colors
extern NSString *const PSPDFAnnotationMenuColor;
extern NSString *const PSPDFAnnotationMenuFillColor;
extern NSString *const PSPDFAnnotationMenuOpacity;
extern NSString *const PSPDFAnnotationMenuCustomColor; // Color Picker
extern NSString *const PSPDFAnnotationMenuColorClear;
extern NSString *const PSPDFAnnotationMenuColorWhite;
extern NSString *const PSPDFAnnotationMenuColorYellow;
extern NSString *const PSPDFAnnotationMenuColorRed;
extern NSString *const PSPDFAnnotationMenuColorPink;
extern NSString *const PSPDFAnnotationMenuColorGreen;
extern NSString *const PSPDFAnnotationMenuColorBlue;
extern NSString *const PSPDFAnnotationMenuColorBlack;

// Highlights
extern NSString *const PSPDFAnnotationMenuHighlightType; // Type
extern NSString *const PSPDFAnnotationMenuHighlight;
extern NSString *const PSPDFAnnotationMenuUnderline;
extern NSString *const PSPDFAnnotationMenuStrikeout;
extern NSString *const PSPDFAnnotationMenuSquiggle;

// Ink
extern NSString *const PSPDFAnnotationMenuThickness;

// Sound annotations
extern NSString *const PSPDFAnnotationMenuPlay;
extern NSString *const PSPDFAnnotationMenuPause;
extern NSString *const PSPDFAnnotationMenuPauseRecording;
extern NSString *const PSPDFAnnotationMenuContinueRecording;
extern NSString *const PSPDFAnnotationMenuFinishRecording;

// Free Text
extern NSString *const PSPDFAnnotationMenuEdit;
extern NSString *const PSPDFAnnotationMenuSize;
extern NSString *const PSPDFAnnotationMenuFont;
extern NSString *const PSPDFAnnotationMenuAlignment;
extern NSString *const PSPDFAnnotationMenuAlignmentLeft;
extern NSString *const PSPDFAnnotationMenuAlignmentCenter;
extern NSString *const PSPDFAnnotationMenuAlignmentRight;
extern NSString *const PSPDFAnnotationMenuFitToText;

// Line/Polyline
extern NSString *const PSPDFAnnotationMenuLineStart; // Start
extern NSString *const PSPDFAnnotationMenuLineEnd;   // End
extern NSString *const PSPDFAnnotationMenuLineTypeNone;
extern NSString *const PSPDFAnnotationMenuLineTypeSquare;
extern NSString *const PSPDFAnnotationMenuLineTypeCircle;
extern NSString *const PSPDFAnnotationMenuLineTypeDiamond;
extern NSString *const PSPDFAnnotationMenuLineTypeOpenArrow;
extern NSString *const PSPDFAnnotationMenuLineTypeClosedArrow;
extern NSString *const PSPDFAnnotationMenuLineTypeButt;
extern NSString *const PSPDFAnnotationMenuLineTypeReverseOpenArrow;
extern NSString *const PSPDFAnnotationMenuLineTypeReverseClosedArrow;
extern NSString *const PSPDFAnnotationMenuLineTypeSlash;

// Signature
extern NSString *const PSPDFAnnotationMenuMySignature;
extern NSString *const PSPDFAnnotationMenuCustomerSignature;
