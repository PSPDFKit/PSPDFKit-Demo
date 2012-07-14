//
//  PSPDFSelectionView.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

#define SelectionViewLinkTappedNotification		@"SelectionViewLinkTappedNotification"
#define SelectionViewStartedDrawingNotification	@"SelectionViewStartedDrawingNotification"

@class PSPDFTextParser, PSPDFWord, PSPDFPageView, PSPDFHighlightAnnotation, PSPDFLinkAnnotation, PSPDFInkAnnotation, PSPDFNoteAnnotation, PSPDFLoupeView;

/// Handles the text and annotation selection.
@interface PSPDFSelectionView : UIView

/// Currently selected glyphs.
@property(nonatomic, strong) NSArray *selectedGlyphs;

/// Currently selected text.
@property(nonatomic, strong) NSString *selectedText;

/// Currently selected text, optimized for searching
@property(nonatomic, strong, readonly) NSString *trimmedSelectedText;

//@property (nonatomic, strong) PSPDFWord *wordSelection;

@property (nonatomic, strong) PSPDFInkAnnotation *selectedInk;

@property (nonatomic, strong) PSPDFHighlightAnnotation *selectedAnnotation;

/// Loupe View for text selection.
@property (nonatomic, strong) PSPDFLoupeView *loupeView;

//@property (nonatomic, assign) CGPoint newNotePoint;

/// Associated PSPDFPageView.
@property (nonatomic, ps_weak) PSPDFPageView *pageView;


- (void)showLoupe;
- (void)hideLoupe;

/// Updates the UIMenuController if there is a selection.
- (void)updateMenu;

/// Clears the current selection.
- (void)discardSelection;

- (BOOL)hasSelection;

- (void)discardInkSelection;

- (void)longPress:(UILongPressGestureRecognizer *)recognizer;
- (BOOL)shouldHandleLongPressWithRecognizer:(UILongPressGestureRecognizer *)recognizer;

- (void)updateSelectionHandleSize;

// debugging
- (void)showTextFlowData:(BOOL)show animated:(BOOL)animated;

@end
