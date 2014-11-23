//
//  PSPDFTextSelectionView.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PSPDFHighlightAnnotation.h"
#import "PSPDFOverridable.h"
#import "PSPDFConfiguration.h"
#import <AVFoundation/AVFoundation.h>

@class PSPDFTextSelectionView, PSPDFImageInfo;

@protocol PSPDFTextSelectionViewDataSource <PSPDFOverridable>

// The document we're operating on.
@property (nonatomic, strong, readonly) PSPDFDocument *document;

// The current page.
@property (nonatomic, assign, readonly) NSUInteger page;

// The parent zoom scale.
@property (nonatomic, assign, readonly) CGFloat zoomScale;

// rect converters
- (CGPoint)convertViewPointToPDFPoint:(CGPoint)viewPoint;
- (CGPoint)convertPDFPointToViewPoint:(CGPoint)pdfPoint;
- (CGRect)convertViewRectToPDFRect:(CGRect)viewRect;
- (CGRect)convertPDFRectToViewRect:(CGRect)pdfRect;
- (CGRect)convertGlyphRectToViewRect:(CGRect)glyphRect;
- (CGRect)convertViewRectToGlyphRect:(CGRect)viewRect;

@optional

@property (nonatomic, assign, getter=isTextSelectionEnabled, readonly) BOOL textSelectionEnabled;
@property (nonatomic, assign, getter=isImageSelectionEnabled, readonly) BOOL imageSelectionEnabled;
@property (nonatomic, assign, readonly) PSPDFTextSelectionMode textSelectionMode;
@property (nonatomic, assign, readonly) BOOL textSelectionShouldSnapToWord;

@end

@protocol PSPDFTextSelectionViewDelegate <NSObject>

// Called whenever there's a good moment to show/hide the menu based on the selection state of `selectedGlyphs` or `selectedImage`.
- (BOOL)textSelectionView:(PSPDFTextSelectionView *)textSelectionView updateMenuAnimated:(BOOL)animated;

@optional

// Called when text is about to be selected. Return NO to disable text selection.
- (BOOL)textSelectionView:(PSPDFTextSelectionView *)textSelectionView shouldSelectText:(NSString *)text withGlyphs:(NSArray *)glyphs atRect:(CGRect)rect;

// Called after text has been selected.
// Will also be called when text has been deselected. Deselection sometimes cannot be stopped, so the `shouldSelectText:` will be skipped.
- (void)textSelectionView:(PSPDFTextSelectionView *)textSelectionView didSelectText:(NSString *)text withGlyphs:(NSArray *)glyphs atRect:(CGRect)rect;

@end


@class PSPDFTextParser, PSPDFWord, PSPDFImageInfo, PSPDFPageView, PSPDFHighlightAnnotation;
@class PSPDFLinkAnnotation, PSPDFAnnotation, PSPDFNoteAnnotation, PSPDFLoupeView, PSPDFLongPressGestureRecognizer;

/// Handles text and image selection.
/// @note Requires the `PSPDFFeatureMaskTextSelection` feature flag.
@interface PSPDFTextSelectionView : UIView <AVSpeechSynthesizerDelegate>

/// The designated initializer for the data source and delegate.
- (instancetype)initWithFrame:(CGRect)frame
                   dataSource:(id <PSPDFTextSelectionViewDataSource>)dataSource
                     delegate:(id <PSPDFTextSelectionViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/// The text selection data source.
@property (nonatomic, weak, readonly) id <PSPDFTextSelectionViewDataSource> dataSource;

/// The text selection delegate.
@property (nonatomic, weak, readonly) id <PSPDFTextSelectionViewDelegate> delegate;

/// Currently selected glyphs.
/// @note Use `sortedGlyphs:` to pre-sort your glyphs if you manually set this.
/// @warning This method expects glyphs to be sorted from top->bottom and left->right for performance reasons.
@property (nonatomic, copy) NSArray *selectedGlyphs;

/// Currently selected text. Set via setting `selectedGlyphs`.
/// Use `discardSelection` to clear.
@property (nonatomic, copy, readonly) NSString *selectedText;

/// Currently selected image.
@property (nonatomic, strong) PSPDFImageInfo *selectedImage;

/// The selection color. Defaults to `UIColor.pspdf_selectionColor`.
@property (nonatomic, strong) UIColor *selectionColor UI_APPEARANCE_SELECTOR;

/// The selection alpha value. Defaults to `UIColor.pspdf_selectionAlpha`.
@property (nonatomic, assign) CGFloat selectionAlpha UI_APPEARANCE_SELECTOR;

/// Currently selected text, optimized for searching
@property (nonatomic, copy, readonly) NSString *trimmedSelectedText;

/// To make it easier to select text, we slightly increase the frame margins. Defaults to 4 pixels.
@property (nonatomic, assign) CGFloat selectionHitTestExtension UI_APPEARANCE_SELECTOR;

/// Rects for the current selection, in view coordinate space.
@property (nonatomic, assign, readonly) CGRect firstLineRect;
@property (nonatomic, assign, readonly) CGRect lastLineRect;
@property (nonatomic, assign, readonly) CGRect selectionRect;

/// Updates the `UIMenuController` if there is a selection.
/// Returns YES if a menu is displayed.
- (BOOL)updateMenuAnimated:(BOOL)animated;

/// Update the selection (text menu).
/// @note `animated` is currently ignored.
- (void)updateSelectionAnimated:(BOOL)animated;

/// Clears the current selection.
- (void)discardSelectionAnimated:(BOOL)animated;

/// Currently has a text/image selection?
- (BOOL)hasSelection;

@end

@interface PSPDFTextSelectionView (Advanced)

// Will return a new array with sorted glyphs.
// Use when you manually call `selectedGlyphs`.
- (NSArray *)sortedGlyphs:(NSArray *)glyphs;

@end

@interface PSPDFTextSelectionView (SubclassingHooks)

// Called when we're adding a new highlight annotation via selected text.
- (void)addHighlightAnnotationWithType:(PSPDFAnnotationType)highlightType;

// Debugging feature, visualizes the text blocks.
- (void)showTextFlowData:(BOOL)show animated:(BOOL)animated;

@end
