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
@property (nonatomic, ps_weak) id<PSPDFSelectionViewDelegate> delegate;

@end
