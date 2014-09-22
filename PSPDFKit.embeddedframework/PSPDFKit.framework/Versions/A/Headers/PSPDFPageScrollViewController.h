//
//  PSPDFPageScrollViewController.h
//  PSPDFKit
//
//  Copyright (c) 2012-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PSPDFBaseViewController.h"
#import "PSPDFTransitionProtocol.h"
#import "PSPDFViewController.h"
#import "PSPDFPresentationContext.h"

@interface PSPDFPagingScrollView : UIScrollView @end

@class PSPDFPageView;

/// Handles the default per-page side-scrolling.
@interface PSPDFPageScrollViewController : PSPDFBaseViewController <PSPDFTransitionProtocol, UIScrollViewDelegate>

/// Designated initializer.
- (instancetype)initWithPresentationContext:(id<PSPDFPresentationContext>)presentationContext NS_DESIGNATED_INITIALIZER;

/// Associated `PSPDFPresentationContext` object.
@property (nonatomic, weak, readonly) id<PSPDFPresentationContext> presentationContext;

/// Main view.
@property (nonatomic, strong, readonly) UIScrollView *pagingScrollView;

/// Access visible page numbers.
- (NSOrderedSet *)visiblePageNumbers;

/// Access the `PSPDFPageView` object for a page, if loaded.
- (PSPDFPageView *)pageViewForPage:(NSUInteger)page;

/// Set Page, animated.
- (void)setPage:(NSUInteger)page animated:(BOOL)animated;

/// Explicitly reload the view.
- (void)reloadData;

@end
