//
//  PSPDFGridViewLayoutStrategy.h
//  PSPDFGridView
//
//  Created by Gulam Moledina on 11-10-28.
//  Copyright (c) 2011-2012 GMoledina.ca. All rights reserved.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PSPDFGridViewLayoutStrategy;


typedef enum {
    PSPDFGridViewLayoutVertical = 0,
    PSPDFGridViewLayoutHorizontal,
    PSPDFGridViewLayoutHorizontalPagedLTR,   // LTR: left to right
    PSPDFGridViewLayoutHorizontalPagedTTB    // TTB: top to bottom
} PSPDFGridViewLayoutStrategyType;



//////////////////////////////////////////////////////////////
#pragma mark - Strategy Factory
//////////////////////////////////////////////////////////////

@interface PSPDFGridViewLayoutStrategyFactory : NSObject

+ (id<PSPDFGridViewLayoutStrategy>)strategyFromType:(PSPDFGridViewLayoutStrategyType)type;

@end


//////////////////////////////////////////////////////////////
#pragma mark - The strategy protocol
//////////////////////////////////////////////////////////////

@protocol PSPDFGridViewLayoutStrategy <NSObject>

+ (BOOL)requiresEnablingPaging;

- (PSPDFGridViewLayoutStrategyType)type;

// Setup
- (void)setupItemSize:(CGSize)itemSize andItemSpacing:(NSInteger)spacing withMinEdgeInsets:(UIEdgeInsets)edgeInsets andCenteredGrid:(BOOL)centered;

// Recomputing
- (void)rebaseWithItemCount:(NSInteger)count insideOfBounds:(CGRect)bounds;

// Fetching the results
- (CGSize)contentSize;
- (CGPoint)originForItemAtPosition:(NSInteger)position;
- (NSInteger)itemPositionFromLocation:(CGPoint)location;

- (NSRange)rangeOfPositionsInBoundsFromOffset:(CGPoint)offset;

@end


//////////////////////////////////////////////////////////////
#pragma mark - Strategy Base class
//////////////////////////////////////////////////////////////

@interface PSPDFGridViewLayoutStrategyBase : NSObject
{
    @protected
    // All of these vars should be set in the init method
    PSPDFGridViewLayoutStrategyType _type;
    
    // All of these vars should be set in the setup method of the child class
    CGSize _itemSize;
    NSInteger _itemSpacing;
    UIEdgeInsets _minEdgeInsets;
    BOOL _centeredGrid;
    
    // All of these vars should be set in the rebase method of the child class
    NSInteger _itemCount;
    UIEdgeInsets _edgeInsets;
    CGRect _gridBounds;
    CGSize _contentSize;
}

@property (nonatomic, readonly) PSPDFGridViewLayoutStrategyType type;

@property (nonatomic, readonly) CGSize itemSize;
@property (nonatomic, readonly) NSInteger itemSpacing;
@property (nonatomic, readonly) UIEdgeInsets minEdgeInsets;
@property (nonatomic, readonly) BOOL centeredGrid;

@property (nonatomic, readonly) NSInteger itemCount;
@property (nonatomic, readonly) UIEdgeInsets edgeInsets;
@property (nonatomic, readonly) CGRect gridBounds;
@property (nonatomic, readonly) CGSize contentSize;

// Protocol methods implemented in base class
- (void)setupItemSize:(CGSize)itemSize andItemSpacing:(NSInteger)spacing withMinEdgeInsets:(UIEdgeInsets)edgeInsets andCenteredGrid:(BOOL)centered;

// Helpers
- (void)setEdgeAndContentSizeFromAbsoluteContentSize:(CGSize)actualContentSize;

@end

//////////////////////////////////////////////////////////////
#pragma mark - Vertical strategy
//////////////////////////////////////////////////////////////

@interface PSPDFGridViewLayoutVerticalStrategy : PSPDFGridViewLayoutStrategyBase <PSPDFGridViewLayoutStrategy>
{
    @protected
    NSInteger _numberOfItemsPerRow;
}

@property (nonatomic, readonly) NSInteger numberOfItemsPerRow;

@end

//////////////////////////////////////////////////////////////
#pragma mark - Horizontal strategy
//////////////////////////////////////////////////////////////

@interface PSPDFGridViewLayoutHorizontalStrategy : PSPDFGridViewLayoutStrategyBase <PSPDFGridViewLayoutStrategy>
{
    @protected
    NSInteger _numberOfItemsPerColumn;
}

@property (nonatomic, readonly) NSInteger numberOfItemsPerColumn;

@end


//////////////////////////////////////////////////////////////
#pragma mark - Horizontal Paged strategy (LTR behavior)
//////////////////////////////////////////////////////////////

@interface PSPDFGridViewLayoutHorizontalPagedStrategy : PSPDFGridViewLayoutHorizontalStrategy
{
    @protected
    NSInteger _numberOfItemsPerRow;
    NSInteger _numberOfItemsPerPage;
    NSInteger _numberOfPages;
}

@property (nonatomic, readonly) NSInteger numberOfItemsPerRow;
@property (nonatomic, readonly) NSInteger numberOfItemsPerPage;
@property (nonatomic, readonly) NSInteger numberOfPages;


// Only these 3 methods have be reimplemented by child classes to change the LTR and TTB kind of behavior
- (NSInteger)positionForItemAtColumn:(NSInteger)column row:(NSInteger)row page:(NSInteger)page;
- (NSInteger)columnForItemAtPosition:(NSInteger)position;
- (NSInteger)rowForItemAtPosition:(NSInteger)position;

@end


//////////////////////////////////////////////////////////////
#pragma mark - Horizontal Paged Left to Right strategy
//////////////////////////////////////////////////////////////

@interface PSPDFGridViewLayoutHorizontalPagedLTRStrategy : PSPDFGridViewLayoutHorizontalPagedStrategy

@end

//////////////////////////////////////////////////////////////
#pragma mark - Horizontal Paged Top To Bottom strategy
//////////////////////////////////////////////////////////////

@interface PSPDFGridViewLayoutHorizontalPagedTTBStrategy : PSPDFGridViewLayoutHorizontalPagedStrategy

@end
