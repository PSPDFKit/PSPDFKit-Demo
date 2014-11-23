//
//  PSPDFPresentationContext.h
//  PSPDFKit
//
//  Copyright (c) 2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import <Foundation/Foundation.h>
#import "PSPDFOverridable.h"
#import "PSPDFConfiguration.h"
#import "PSPDFControlDelegate.h"

@class PSPDFKit, PSPDFConfiguration, PSPDFPageView, PSPDFDocument, PSPDFViewController, PSPDFAnnotationStateManager, PSPDFAnnotation;

// The presentation context (usually defined by `PSPDFViewController`).
@protocol PSPDFPresentationContext <PSPDFOverridable>

// Accesses the configuration object.
@property (nonatomic, copy, readonly) PSPDFConfiguration *configuration;

// Access the PSPDFKit singleton store.
@property (nonatomic, strong, readonly) PSPDFKit *pspdfkit;

// The displaying view controller and popover/half modal controllers
@property (nonatomic, strong, readonly) UIViewController *displayingViewController;
@property (nonatomic, strong, readonly) UIPopoverController *popoverController;
@property (nonatomic, strong, readonly) UIViewController *halfModalController;

// Could be removed
@property (nonatomic, strong, readonly) UIViewController *visibleViewControllerInPopoverController;

// General state
@property (nonatomic, strong, readonly) PSPDFDocument *document;
@property (nonatomic, assign, readonly) NSUInteger page;
@property (nonatomic, assign, readonly) PSPDFViewMode viewMode;

@property (nonatomic, assign, readonly) CGRect contentRect;
@property (nonatomic, assign, readonly) UIEdgeInsets scrollViewInsets;

// Various state.
@property (nonatomic, assign, getter = isDoublePageMode,   readonly) BOOL doublePageMode;
@property (nonatomic, assign, getter = isScrollingEnabled, readonly) BOOL scrollingEnabled;
@property (nonatomic, assign, getter = isViewLockEnabled,  readonly) BOOL viewLockEnabled;
@property (nonatomic, assign, getter = isRotationActive, readonly) BOOL rotationActive;
@property (nonatomic, assign, getter = isHUDVisible, readonly) BOOL HUDVisible;
@property (nonatomic, assign, getter = isViewWillAppearing, readonly) BOOL viewWillAppearing;

// Page views
- (NSArray *)visiblePageViews;
- (NSArray *)visiblePageViewsForcingLayout:(BOOL)forcingLayout;
- (PSPDFPageView *)pageViewForPage:(NSUInteger)page;

- (CGRect)annotationRectForAnnotation:(PSPDFAnnotation *)annotation;

// Page numbers
- (NSArray *)calculatedVisiblePageNumbers;
- (BOOL)isRightPageInDoublePageMode:(NSUInteger)page;
- (BOOL)isDoublePageModeForLandscape:(BOOL)isLandscape;
- (BOOL)isDoublePageModeForPage:(NSUInteger)page;
- (NSUInteger)portraitPageForLandscapePage:(NSUInteger)page;
- (NSUInteger)landscapePageForPage:(NSUInteger)aPage;

@property (nonatomic, strong, readonly) UIScrollView *pagingScrollView;

// Accesses the global annotation state manager.
@property (nonatomic, strong, readonly) PSPDFAnnotationStateManager *annotationStateManager;

// TODO: Should be a delegate instead.
@property (nonatomic, strong, readonly) id <PSPDFControlDelegate> actionDelegate;

// Direct access to the `PSPDFViewController` if required.
@property (nonatomic, strong, readonly) PSPDFViewController *pdfController;

@end
