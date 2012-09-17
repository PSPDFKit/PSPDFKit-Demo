//
//  PSPDFTextSelectionView.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFTextParser, PSPDFWord, PSPDFPageView, PSPDFHighlightAnnotation, PSPDFLinkAnnotation, PSPDFAnnotation, PSPDFNoteAnnotation, PSPDFLoupeView;

/// Handles the text and annotation selection.
/// Only available in PSPDFKit Annotate.
@interface PSPDFTextSelectionView : UIView

/// Currently selected glyphs.
@property(nonatomic, strong) NSArray *selectedGlyphs;

/// Currently selected text.
@property(nonatomic, strong) NSString *selectedText;

/// Currently selected text, optimized for searching
@property(nonatomic, strong, readonly) NSString *trimmedSelectedText;

/// Currently selected annotation
@property(nonatomic, strong) PSPDFAnnotation *selectedAnnotation;

/// Loupe View for text selection.
@property(nonatomic, strong) PSPDFLoupeView *loupeView;

/// Associated PSPDFPageView.
@property(nonatomic, ps_weak) PSPDFPageView *pageView;

// Text Loupe control code
- (void)showLoupe;
- (void)hideLoupe;

/// Updates the UIMenuController if there is a selection.
- (void)updateMenu;

/// Clears the current selection.
- (void)discardSelection;
- (BOOL)hasSelection;

// gesture handling
- (void)longPress:(UILongPressGestureRecognizer *)recognizer;
- (BOOL)shouldHandleLongPressWithRecognizer:(UILongPressGestureRecognizer *)recognizer;

- (void)updateSelectionHandleSize;

// debugging
- (void)showTextFlowData:(BOOL)show animated:(BOOL)animated;

/// Text selection is only available in PSPDFKit Annotate
+ (BOOL)isTextSelectionFeatureAvailable;

@end
