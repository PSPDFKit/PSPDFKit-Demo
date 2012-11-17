//
//  PSPDFSelectionView.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"

@class PSPDFSelectionView;

@protocol PSPDFSelectionViewDelegate <NSObject>

@optional

/// called before we start selecting. No further delegates will be called for the following touch events until filter is lifted and started again if we return NO here. (touchesBegan)
- (BOOL)selectionView:(PSPDFSelectionView *)selectionView shouldStartSelectionAtPoint:(CGPoint)point;

/// Rect is updated. (touchesMoved)
- (void)selectionView:(PSPDFSelectionView *)selectionView updateSelectedRect:(CGRect)rect;

/// Called when a rect was selected successfully. (touchesEnded)
- (void)selectionView:(PSPDFSelectionView *)selectionView finishedWithSelectedRect:(CGRect)rect;

/// Called when rect selection was cancelled. (touchesCancelled)
- (void)selectionView:(PSPDFSelectionView *)selectionView cancelledWithSelectedRect:(CGRect)rect;

@end

// Captures touches and marks text as selected for annotations.
// (Does use instant-select, not long-presses like PSPDFSelectionView)
@interface PSPDFSelectionView : UIView

/// Designated initializer
- (id)initWithFrame:(CGRect)frame delegate:(id<PSPDFSelectionViewDelegate>)delegate;

/// Selection View delegate.
@property (nonatomic, weak) id<PSPDFSelectionViewDelegate> delegate;

/// Color used to span the selection. Defaults to iOS selection blue.
@property (nonatomic, strong) UIColor *selectionColor;

/// Color used to select words. Defaults to a darker iOS selection blue.
@property (nonatomic, strong) UIColor *wordSelectionColor;

/// Allows to mark an array of CGRects on the view. rects and rawRects are mutually exclusive and will nil out each other.
@property (nonatomic, strong) NSArray *rects;

/// Faster variant that takes a C rect array. Will take ownership and free up memory after usage.
/// rects and rawRects are mutually exclusive and will nil out each other.
- (void)setRawRects:(CGRect *)rawRects count:(NSUInteger)count;

@end
