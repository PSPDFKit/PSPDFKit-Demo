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

typedef NS_ENUM(NSUInteger, PSPDFAnnotationToolbarMode) {
    PSPDFAnnotationToolbarNone,
    PSPDFAnnotationToolbarNote,
    PSPDFAnnotationToolbarHighlight,
    PSPDFAnnotationToolbarStrikeOut,
    PSPDFAnnotationToolbarUnderline,
    PSPDFAnnotationToolbarFreeText,
    PSPDFAnnotationToolbarDraw
};

/// Delegate to be notified on toolbar actions/hiding.
@protocol PSPDFAnnotationToolbarDelegate <NSObject>

@optional

// Called when the Done button has been pressed to hide the toolbar.
- (void)annotationToolbarDidHide:(PSPDFAnnotationToolbar *)annotationToolbar;

// Called after a mode change is set (button pressed; drawing finished, etc)
- (void)annotationToolbar:(PSPDFAnnotationToolbar *)annotationToolbar didChangeMode:(PSPDFAnnotationToolbarMode)newMode;

@end

/// To edit annotations, a new toolbar will be overlayed.
/// You can also use the features of the toolbar in the background and make your own UI.
/// (for custom UI, don't show the toolbar, manually call the buttons and let the toolbar perform all the state handling)
@interface PSPDFAnnotationToolbar : UIToolbar <PSPDFDrawViewDelegate, PSPDFSelectionViewDelegate>

/// Designated initializer.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// Show the toolbar in target rect. Rect should be the same height as the toolbar. (44px)
/// You need to manually add the toolbar to the view. This is just to get the animation right.
- (void)showToolbarInRect:(CGRect)rect animated:(BOOL)animated;

/// Hide the toolbar.
/// You need to manually remove the toolbar from the view in the completion block. This is just to get the animation right.
- (void)hideToolbarAnimated:(BOOL)animated completion:(dispatch_block_t)completionBlock;

/// Flash toolbar if user tries to hide the HUD.
- (void)flashToolbar;

/// Annotation toolbar delegate.
@property (nonatomic, strong) id<PSPDFAnnotationToolbarDelegate> delegate;

/// Attached pdfController.
@property (nonatomic, weak) PSPDFViewController *pdfController;

/// Active annotation toolbar mode.
@property (nonatomic, assign) PSPDFAnnotationToolbarMode toolbarMode;

@end

@interface PSPDFAnnotationToolbar (PSPDFSubclassing)

- (void)noteButtonPressed:(id)sender;
- (void)highlightButtonPressed:(id)sender;
- (void)strikeOutButtonPressed:(id)sender;
- (void)underlineButtonPressed:(id)sender;
- (void)drawButtonPressed:(id)sender;
- (void)doneButtonPressed:(id)sender;

// Finish up drawing. Usually called by the drawing delegate.
- (void)finishDrawingAndSaveAnnotation:(BOOL)save;

// helpers to lock/unlock the controller
- (void)lockPDFController;

// stayOnTop is a runtime tweak to make sure the toolbar stays above the pfController navigationBar.
- (void)unlockPDFControllerAndEnsureToStayOnTop:(BOOL)stayOnTop;

@end