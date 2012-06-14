//
//  PSPDFSelectionView.h
//  PSPDFKit
//
//  Copyright 2012 Peter Steinberger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AVFoundation/AVFoundation.h>
#import "PSPDFKitGlobal.h"

#define SelectionViewLinkTappedNotification		@"SelectionViewLinkTappedNotification"
#define SelectionViewStartedDrawingNotification	@"SelectionViewStartedDrawingNotification"

@class PSPDFTextParser, PSPDFWord, PSPDFPageView, PSPDFHighlightAnnotation, PSPDFLinkAnnotation, PSPDFInkAnnotation, PSPDFTextAnnotation, PSPDFLoupeView, TextNoteView, Annotation;

@interface PSPDFSelectionView : UIView {
	PSPDFPageView *__ps_weak pageView;

	UIImageView *startHandle;
	UIImageView *endHandle;

	UIView *startDelimiter;
	UIView *endDelimiter;

	CGPoint startPoint;
	CGPoint endPoint;

	int draggingHandle;			//-1 for not dragging, 0 for start handle, 1 for end handle

	UIView *firstLineView;
	UIView *lastLineView;
	UIView *bodyView;

	PSPDFLoupeView *loupeView;
	UIView *wordSelectionView;

	UIView *inkSelectionView;
	PSPDFHighlightAnnotation *selectedAnnotation;
	CGRect menuTargetRect;

	NSMutableArray *textNoteViews;

	UIView *linkHighlightView;

	CGPoint newNotePoint;
//	TextNoteView *draggingTextNoteView;

	BOOL selectedHighlightAnnotationHasText;

	CGPoint pageAnalysisStartLocation;
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

//debugging
- (void)showTextFlowData:(BOOL)show animated:(BOOL)animated;

/*
- (NSArray *)reduceGlyphsToColumn:(NSArray *)glyphs;
- (BOOL)handleTap:(UITapGestureRecognizer *)recognizer;
- (void)reloadTextAnnotationsWithPage:(PDFPage *)pdfPage;
- (void)editTextAnnotation:(TextAnnotation *)annotation;
- (void)showMenuForSelectedAnnotation:(UIGestureRecognizer *)recognizer;
- (void)editNote:(TextNoteView *)noteView withKeyboard:(BOOL)showKeyboard;
- (void)editSound:(TextNoteView *)soundView;
- (void)updateInkSelectionWithLocation:(CGPoint)location;
- (LinkAnnotation *)linkAtTouchLocation:(CGPoint)location;
- (void)openLink:(LinkAnnotation *)link atTouchLocation:(CGPoint)location;
- (CGRect)frameForAnnotation:(Annotation *)annotation;
- (CGRect)rectForSheetWithLink:(LinkAnnotation *)link withTouchLocation:(CGPoint)location;
- (void)changeHighlightColor:(PSPDFColor)color;
- (void)changeUnderlineColor:(PSPDFColor)color;
- (void)changeStrikeOutColor:(PSPDFColor)color;
- (void)moveHandle:(UILongPressGestureRecognizer *)recognizer;
- (void)updateWordSelectionWithLocation:(CGPoint)location;
- (void)updateMenu;
- (void)addAnnotationWithType:(NSString *)annotationType;
- (void)addNote:(id)sender;
- (void)addSound:(id)sender;
- (void)selectClosestWordToPoint:(CGPoint)location;
- (CGRect)convertRectFromPageCoordinates:(CGRect)rect;
- (void)selectInkAnnotation:(PSPDFInkAnnotation *)annotation;
- (void)showInkMenu:(UITapGestureRecognizer *)recognizer;
*/

@end
