//
//  PSPDFSelectionView.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
#import "PSPDFKitGlobal.h"

#define SelectionViewLinkTappedNotification		@"SelectionViewLinkTappedNotification"
#define SelectionViewStartedDrawingNotification	@"SelectionViewStartedDrawingNotification"

@class PSPDFTextParser, PSPDFWord, PSPDFPageView, PSPDFHighlightAnnotation, PSPDFLinkAnnotation, PSPDFInkAnnotation, PSPDFNoteAnnotation, PSPDFLoupeView, TextNoteView, Annotation;

@interface PSPDFSelectionView : UIView {
	PSPDFPageView *__ps_weak _pageView;

	UIImageView *_startHandle;
	UIImageView *_endHandle;

	UIView *_startDelimiter;
	UIView *_endDelimiter;

	CGPoint _startPoint;
	CGPoint _endPoint;

	int _draggingHandle;			//-1 for not dragging, 0 for start handle, 1 for end handle

	UIView *_firstLineView;
	UIView *_lastLineView;
	UIView *_bodyView;

	PSPDFLoupeView *_loupeView;
	UIView *_wordSelectionView;

	UIView *_inkSelectionView;
	PSPDFHighlightAnnotation *_selectedAnnotation;
	CGRect _menuTargetRect;

	NSMutableArray *_textNoteViews;

	UIView *_linkHighlightView;

	CGPoint _newNotePoint;
//	TextNoteView *draggingTextNoteView;

	BOOL _selectedHighlightAnnotationHasText;

	CGPoint _pageAnalysisStartLocation;
}

@property (nonatomic, strong) NSArray *selectedGlyphs;
@property (nonatomic, strong) NSString *selectedText;
@property (nonatomic, strong) PSPDFWord *wordSelection;
@property (nonatomic, strong) PSPDFInkAnnotation *selectedInk;
@property (nonatomic, ps_weak) PSPDFPageView *pageView;
@property (nonatomic, strong) PSPDFHighlightAnnotation *selectedAnnotation;
@property (nonatomic, strong) PSPDFLoupeView *loupeView;
@property (nonatomic, strong) PSPDFLinkAnnotation *selectedLink;
@property (nonatomic, strong) TextNoteView *draggingTextNoteView;
@property (nonatomic, assign) CGPoint newNotePoint;

- (void)showLoupe;
- (void)hideLoupe;

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
