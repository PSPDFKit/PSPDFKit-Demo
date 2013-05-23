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

/// Handles text selection. PSPDFKit Annotate feature.
@interface PSPDFTextSelectionView : UIView

/// Currently selected glyphs.
@property (nonatomic, copy) NSArray *selectedGlyphs;

/// Currently selected text.
@property (nonatomic, copy) NSString *selectedText;

/// Currently selected image.
@property (nonatomic, strong) PSPDFImageInfo *selectedImage;

/// Currently selected text, optimized for searching
@property (nonatomic, copy, readonly) NSString *trimmedSelectedText;

/// Associated PSPDFPageView.
@property (nonatomic, unsafe_unretained) PSPDFPageView *pageView;

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

/// Text selection is only available in PSPDFKit Annotate
+ (BOOL)isTextSelectionFeatureAvailable;

@end

@interface PSPDFTextSelectionView (SubclassingHooks)

// Returns the menu items for selected text. Can be customized here or in the shouldShowMenu: delegate.
- (NSArray *)menuItemsForTextSelection:(NSString *)selectedText;

// Returns the menu items for selected image. Can be customized here or in the shouldShowMenu: delegate.
- (NSArray *)menuItemsForImageSelection:(PSPDFImageInfo *)imageSelection;

// Called when we're adding a new highlight annotation via selected text.
- (void)addHighlightAnnotationWithType:(PSPDFHighlightAnnotationType)highlightType;

// Debugging feature, visualizes the text blocks.
- (void)showTextFlowData:(BOOL)show animated:(BOOL)animated;

// gesture handling
- (BOOL)longPress:(UILongPressGestureRecognizer *)recognizer;

- (BOOL)pressRecognizerShouldHandlePressImmediately:(PSPDFLongPressGestureRecognizer *)recognizer;

- (BOOL)isDragHandleSelected;

@end
