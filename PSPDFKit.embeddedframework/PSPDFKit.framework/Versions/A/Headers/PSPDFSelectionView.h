//
//  PSPDFSelectionView.h
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

@class PSPDFSelectionView;

@protocol PSPDFSelectionViewDelegate <NSObject>

@optional

/// Called before we start selecting. If we return NO here, no selection will be drawn (but delegates will still be displayed)
- (BOOL)selectionView:(PSPDFSelectionView *)selectionView shouldStartSelectionAtPoint:(CGPoint)point;

/// Rect is updated. (`touchesMoved:`)
- (void)selectionView:(PSPDFSelectionView *)selectionView updateSelectedRect:(CGRect)rect;

/// Called when a rect was selected successfully. (`touchesEnded:`)
- (void)selectionView:(PSPDFSelectionView *)selectionView finishedWithSelectedRect:(CGRect)rect;

/// Called when rect selection was cancelled. (`touchesCancelled:`)
- (void)selectionView:(PSPDFSelectionView *)selectionView cancelledWithSelectedRect:(CGRect)rect;

/// Called when we did a single tap in the selection view (via tap gesture recognizer)
- (void)selectionView:(PSPDFSelectionView *)selectionView singleTappedWithGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer;

@end

// Captures touches and marks text as selected for annotations.
@interface PSPDFSelectionView : UIView

/// Designated initializer
- (instancetype)initWithFrame:(CGRect)frame delegate:(id<PSPDFSelectionViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

/// Selection View delegate.
@property (nonatomic, weak) id<PSPDFSelectionViewDelegate> delegate;

/// Color used to span the selection. Defaults to iOS selection blue.
@property (nonatomic, strong) UIColor *selectionColor;

/// Color used to select words. Defaults to a darker iOS selection blue.
@property (nonatomic, strong) UIColor *wordSelectionColor;

/// Allows to mark an array of `CGRects` on the view. `rects` and `rawRects` are mutually exclusive and will nil out each other.
@property (nonatomic, strong) NSArray *rects;

/// Faster variant that takes a C rect array. Will take ownership and free up memory after usage.
/// rects and rawRects are mutually exclusive and will nil out each other.
- (void)setRawRects:(CGRect *)rawRects count:(NSUInteger)count;

// Internal tap gesture.
@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapGestureRecognizer;

@end
