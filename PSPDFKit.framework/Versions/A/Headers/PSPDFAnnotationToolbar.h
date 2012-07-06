//
//  PSPDFAnnotationToolbar.h
//  PSPDFKit
//
//  Copyright (c) 2012 Peter Steinberger. All rights reserved.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFDrawView.h"

@class PSPDFViewController;

/// To edit annotations, a new toolbar will be overlayed.
@interface PSPDFAnnotationToolbar : UIToolbar <PSPDFDrawViewDelegate>

- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// Show the toolbar in target rect. Rect should be the same height as the toolbar. (44px)
- (void)showToolbarInRect:(CGRect)rect animated:(BOOL)animated;

/// Hide the toolbar.
- (void)hideToolbarAnimated:(BOOL)animated;

@property(nonatomic, ps_weak) PSPDFViewController *pdfController;

@end


@interface PSPDFAnnotationToolbar (PSPDFSubclassing)

- (void)commentButtonPressed:(UIBarButtonItem *)barButtonItem;
- (void)highlightButtonPressed:(UIBarButtonItem *)barButtonItem;
- (void)strikeOutButtonPressed:(UIBarButtonItem *)barButtonItem;
- (void)underlineButtonPressed:(UIBarButtonItem *)barButtonItem;
- (void)drawButtonPressed:(UIBarButtonItem *)barButtonItem;
- (void)backButtonPressed:(UIBarButtonItem *)barButtonItem;

@end