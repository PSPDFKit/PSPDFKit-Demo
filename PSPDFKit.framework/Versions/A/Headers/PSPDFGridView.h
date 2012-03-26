//
//  PSPDFGridView.h
//  PSPDFGridView
//
//  Created by Gulam Moledina on 11-10-09.
//  Copyright (C) 2011 by Gulam Moledina.
//
//  Latest code can be found on GitHub: https://github.com/gmoledina/PSPDFGridView
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "PSPDFGridViewCell.h"
#import "PSPDFKitGlobal.h"

#define GMGV_INVALID_POSITION -1

@protocol PSPDFGridViewDataSource;
@protocol PSPDFGridViewActionDelegate;
@protocol PSPDFGridViewSortingDelegate;
@protocol PSPDFGridViewTransformationDelegate;
@protocol PSPDFGridViewLayoutStrategy;

typedef enum
{
    PSPDFGridViewStylePush = 0,
    PSPDFGridViewStyleSwap
} PSPDFGridViewStyle;

typedef enum
{
	PSPDFGridViewScrollPositionNone,
	PSPDFGridViewScrollPositionTop,
	PSPDFGridViewScrollPositionMiddle,
	PSPDFGridViewScrollPositionBottom
} PSPDFGridViewScrollPosition;

typedef enum
{
    PSPDFGridViewItemAnimationNone = 0,
    PSPDFGridViewItemAnimationFade,
    PSPDFGridViewItemAnimationScroll = 1<<7 // scroll to the item before showing the animation
} PSPDFGridViewItemAnimation;

//////////////////////////////////////////////////////////////
#pragma mark Interface PSPDFGridView
//////////////////////////////////////////////////////////////

@interface PSPDFGridView : UIScrollView

// Delegates
@property (nonatomic, ps_weak) IBOutlet NSObject<PSPDFGridViewDataSource> *dataSource;                    // Required
@property (nonatomic, ps_weak) IBOutlet NSObject<PSPDFGridViewActionDelegate> *actionDelegate;            // Optional - to get taps callback & deleting item
@property (nonatomic, ps_weak) IBOutlet NSObject<PSPDFGridViewSortingDelegate> *sortingDelegate;          // Optional - to enable sorting
@property (nonatomic, ps_weak) IBOutlet NSObject<PSPDFGridViewTransformationDelegate> *transformDelegate; // Optional - to enable fullsize mode

// Layout Strategy
@property (nonatomic, strong) IBOutlet id<PSPDFGridViewLayoutStrategy> layoutStrategy; // Default is PSPDFGridViewLayoutVerticalStrategy

// Editing Mode
@property (nonatomic, getter=isEditing) BOOL editing; // Default is NO - When set to YES, all gestures are disabled and delete buttons shows up on cells
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;

// Customizing Options
@property (nonatomic, ps_weak) IBOutlet UIView *mainSuperView;        // Default is self
@property (nonatomic) PSPDFGridViewStyle style;                          // Default is PSPDFGridViewStyleSwap
@property (nonatomic) NSInteger itemSpacing;                          // Default is 10
@property (nonatomic) BOOL centerGrid;                                // Default is YES
@property (nonatomic) UIEdgeInsets minEdgeInsets;                     // Default is (5, 5, 5, 5)
@property (nonatomic) CFTimeInterval minimumPressDuration;            // Default is 0.2; if set to 0, the view wont be scrollable
@property (nonatomic) BOOL showFullSizeViewWithAlphaWhenTransforming; // Default is YES - not working right now

@property (nonatomic, readonly) UIScrollView *scrollView __attribute__((deprecated)); // The grid now inherits directly from UIScrollView

// Reusable cells
- (PSPDFGridViewCell *)dequeueReusableCell;                              // Should be called in PSPDFGridView:cellForItemAtIndex: to reuse a cell
- (PSPDFGridViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier;

// Cells
- (PSPDFGridViewCell *)cellForItemAtIndex:(NSInteger)position;           // Might return nil if cell not loaded yet

// Actions
- (void)reloadData;
- (void)insertObjectAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)insertObjectAtIndex:(NSInteger)index withAnimation:(PSPDFGridViewItemAnimation)animation;
- (void)removeObjectAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)removeObjectAtIndex:(NSInteger)index withAnimation:(PSPDFGridViewItemAnimation)animation;
- (void)reloadObjectAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadObjectAtIndex:(NSInteger)index withAnimation:(PSPDFGridViewItemAnimation)animation;
- (void)swapObjectAtIndex:(NSInteger)index1 withObjectAtIndex:(NSInteger)index2 animated:(BOOL)animated;
- (void)swapObjectAtIndex:(NSInteger)index1 withObjectAtIndex:(NSInteger)index2 withAnimation:(PSPDFGridViewItemAnimation)animation;
- (void)scrollToObjectAtIndex:(NSInteger)index atScrollPosition:(PSPDFGridViewScrollPosition)scrollPosition animated:(BOOL)animated;

// Force the grid to update properties in an (probably) animated way.
- (void)layoutSubviewsWithAnimation:(PSPDFGridViewItemAnimation)animation;

@end


//////////////////////////////////////////////////////////////
#pragma mark Protocol PSPDFGridViewDataSource
//////////////////////////////////////////////////////////////

@protocol PSPDFGridViewDataSource <NSObject>

@required
// Populating subview items 
- (NSInteger)numberOfItemsInPSPDFGridView:(PSPDFGridView *)gridView;
- (CGSize)PSPDFGridView:(PSPDFGridView *)gridView sizeForItemsInInterfaceOrientation:(UIInterfaceOrientation)orientation;
- (PSPDFGridViewCell *)PSPDFGridView:(PSPDFGridView *)gridView cellForItemAtIndex:(NSInteger)index;

@optional
// Allow a cell to be deletable. If not implemented, YES is assumed.
- (BOOL)PSPDFGridView:(PSPDFGridView *)gridView canDeleteItemAtIndex:(NSInteger)index;

@end


//////////////////////////////////////////////////////////////
#pragma mark Protocol PSPDFGridViewActionDelegate
//////////////////////////////////////////////////////////////

@protocol PSPDFGridViewActionDelegate <NSObject>

@required
- (void)PSPDFGridView:(PSPDFGridView *)gridView didTapOnItemAtIndex:(NSInteger)position;

@optional
// Tap on space without any items
- (void)PSPDFGridViewDidTapOnEmptySpace:(PSPDFGridView *)gridView;
// Called when the delete-button has been pressed. Required to enable editing mode.
// This method wont delete the cell automatically. Call the delete method of the gridView when appropriate.
- (void)PSPDFGridView:(PSPDFGridView *)gridView processDeleteActionForItemAtIndex:(NSInteger)index;

@end


//////////////////////////////////////////////////////////////
#pragma mark Protocol PSPDFGridViewSortingDelegate
//////////////////////////////////////////////////////////////

@protocol PSPDFGridViewSortingDelegate <NSObject>

@required
// Item moved - right place to update the data structure
- (void)PSPDFGridView:(PSPDFGridView *)gridView moveItemAtIndex:(NSInteger)oldIndex toIndex:(NSInteger)newIndex;
- (void)PSPDFGridView:(PSPDFGridView *)gridView exchangeItemAtIndex:(NSInteger)index1 withItemAtIndex:(NSInteger)index2;

@optional
// Sorting started/ended - indexes are not specified on purpose (not the right place to update data structure)
- (void)PSPDFGridView:(PSPDFGridView *)gridView didStartMovingCell:(PSPDFGridViewCell *)cell;
- (void)PSPDFGridView:(PSPDFGridView *)gridView didEndMovingCell:(PSPDFGridViewCell *)cell;
// Enable/Disable the shaking behavior of an item being moved
- (BOOL)PSPDFGridView:(PSPDFGridView *)gridView shouldAllowShakingBehaviorWhenMovingCell:(PSPDFGridViewCell *)view atIndex:(NSInteger)index;

@end

//////////////////////////////////////////////////////////////
#pragma mark Protocol PSPDFGridViewTransformationDelegate
//////////////////////////////////////////////////////////////

@protocol PSPDFGridViewTransformationDelegate <NSObject>

@required
// Fullsize
- (CGSize)PSPDFGridView:(PSPDFGridView *)gridView sizeInFullSizeForCell:(PSPDFGridViewCell *)cell atIndex:(NSInteger)index inInterfaceOrientation:(UIInterfaceOrientation)orientation;
- (UIView *)PSPDFGridView:(PSPDFGridView *)gridView fullSizeViewForCell:(PSPDFGridViewCell *)cell atIndex:(NSInteger)index;

// Transformation (pinch, drag, rotate) of the item
@optional
- (void)PSPDFGridView:(PSPDFGridView *)gridView didStartTransformingCell:(PSPDFGridViewCell *)cell;
- (void)PSPDFGridView:(PSPDFGridView *)gridView didEnterFullSizeForCell:(PSPDFGridViewCell *)cell;
- (void)PSPDFGridView:(PSPDFGridView *)gridView didEndTransformingCell:(PSPDFGridViewCell *)cell;

@end
