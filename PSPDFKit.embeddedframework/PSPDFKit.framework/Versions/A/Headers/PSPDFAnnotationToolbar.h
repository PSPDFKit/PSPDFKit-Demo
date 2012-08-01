//
//  PSPDFAnnotationToolbar.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFDrawView.h"
#import "PSPDFSelectionView.h"

@class PSPDFViewController, PSPDFAnnotationToolbar;

@protocol PSPDFAnnotationToolbarDelegate <NSObject>

- (void)annotationToolbarDidHide:(PSPDFAnnotationToolbar *)annotationToolbar;

@end

typedef NS_ENUM(NSUInteger, PSPDFAnnotationToolbarMode) {
    PSPDFAnnotationToolbarNone,
    PSPDFAnnotationToolbarComment,
    PSPDFAnnotationToolbarHighlight,
    PSPDFAnnotationToolbarStrikeOut,
    PSPDFAnnotationToolbarUnderline,
    PSPDFAnnotationToolbarDraw
};

/// To edit annotations, a new toolbar will be overlayed.
@interface PSPDFAnnotationToolbar : UIToolbar <PSPDFDrawViewDelegate, PSPDFSelectionViewDelegate>

/// Designated initializer.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// Show the toolbar in target rect. Rect should be the same height as the toolbar. (44px)
- (void)showToolbarInRect:(CGRect)rect animated:(BOOL)animated;

/// Hide the toolbar.
- (void)hideToolbarAnimated:(BOOL)animated completion:(dispatch_block_t)completionBlock;

/// Annotation Toolbar delegate.
@property(nonatomic, strong) id<PSPDFAnnotationToolbarDelegate> delegate;

/// Attached pdfController.
@property(nonatomic, ps_weak) PSPDFViewController *pdfController;

/// Active annotation toolbar mode.
@property(nonatomic, assign) PSPDFAnnotationToolbarMode toolbarMode;

@end


@interface PSPDFAnnotationToolbar (PSPDFSubclassing)

- (void)commentButtonPressed:(UIBarButtonItem *)barButtonItem;
- (void)highlightButtonPressed:(UIBarButtonItem *)barButtonItem;
- (void)strikeOutButtonPressed:(UIBarButtonItem *)barButtonItem;
- (void)underlineButtonPressed:(UIBarButtonItem *)barButtonItem;
- (void)drawButtonPressed:(UIBarButtonItem *)barButtonItem;
- (void)backButtonPressed:(UIBarButtonItem *)barButtonItem;

@end