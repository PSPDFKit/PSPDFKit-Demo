//
//  PSPDFTextSelectionView.h
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
#import "PSPDFHighlightAnnotation.h"

@class PSPDFTextParser, PSPDFWord, PSPDFImageInfo, PSPDFPageView, PSPDFHighlightAnnotation, PSPDFLinkAnnotation, PSPDFAnnotation, PSPDFNoteAnnotation, PSPDFLoupeView, PSPDFLongPressGestureRecognizer;

/// Handles text selection. PSPDFKit Basic/Complete feature.
@interface PSPDFTextSelectionView : UIView

/// Currently selected glyphs.
/// @warning This method expects glyphs to be sorted from top->bottom and left->right for performance reasons.
/// Use `sortedGlyphs:` to pre-sort your glyphs if you manually set this.
@property (nonatomic, copy) NSArray *selectedGlyphs;

/// Currently selected text.
@property (nonatomic, copy) NSString *selectedText;

/// Currently selected image.
@property (nonatomic, strong) PSPDFImageInfo *selectedImage;

/// The selection color. Defaults to [UIColor pspdf_selectionColor].
@property (nonatomic, strong) UIColor *selectionColor;

/// The selection alpha value. Defaults to [UIColor pspdf_selectionAlpha].
@property (nonatomic, assign) CGFloat selectionAlpha;

/// In simple selection mode, the initial selection switches to moving the drag handles directly, much like iBooks handles selection. Defaults to NO.
@property (nonatomic, assign) BOOL simpleSelectionModeEnabled;

/// To make it easier to select text, we slightly increase the frame margins. Defaults to 4 pixels.
@property (nonatomic, assign) CGFloat selectionHitTestExtension;

/// Currently selected text, optimized for searching
@property (nonatomic, copy, readonly) NSString *trimmedSelectedText;

/// Associated PSPDFPageView.
@property (nonatomic, weak) PSPDFPageView *pageView;

/// rects for the current selection, in view coordinate space.
@property (nonatomic, assign, readonly) CGRect firstLineRect;
@property (nonatomic, assign, readonly) CGRect lastLineRect;
@property (nonatomic, assign, readonly) CGRect selectionRect;

/// Updates the UIMenuController if there is a selection.
/// Returns YES if a menu is displayed.
- (BOOL)updateMenuAnimated:(BOOL)animated;

/// Update the selection (text menu).
- (void)updateSelection;

/// Clears the current selection.
- (void)discardSelection;

/// Currently has a text/image selection?
- (BOOL)hasSelection;

/// Text selection is only available in PSPDFKit Basic/Complete.
+ (BOOL)isTextSelectionFeatureAvailable;

@end

@interface PSPDFTextSelectionView (Advanced)

// Will return a new array with sorted glyphs.
// Use when you manually call `selectedGlyphs`.
- (NSArray *)sortedGlyphs:(NSArray *)glyphs;

// Will present a Wikipedia browser anchored at the selected text.
// Used in iOS 5/6 when there's no dictionary entry. Not used in iOS 7 as Define has it's own Wikipedia link there.
- (UIViewController *)presentWikipediaBrowserForSelectedText;

@end

@interface PSPDFTextSelectionView (SubclassingHooks)

// Returns the menu items for selected text. Can be customized here or in the shouldShowMenu: delegate.
- (NSArray *)menuItemsForTextSelection:(NSString *)selectedText;

// Returns the menu items for selected image. Can be customized here or in the shouldShowMenu: delegate.
- (NSArray *)menuItemsForImageSelection:(PSPDFImageInfo *)imageSelection;

// Called when we're adding a new highlight annotation via selected text.
- (void)addHighlightAnnotationWithType:(PSPDFAnnotationType)highlightType;

// Debugging feature, visualizes the text blocks.
- (void)showTextFlowData:(BOOL)show animated:(BOOL)animated;

// gesture handling
- (BOOL)longPress:(UILongPressGestureRecognizer *)recognizer;

- (BOOL)pressRecognizerShouldHandlePressImmediately:(PSPDFLongPressGestureRecognizer *)recognizer;

- (BOOL)isDragHandleSelected;

@end
