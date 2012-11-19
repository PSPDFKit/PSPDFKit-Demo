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

// constants which are used for NSUserDefaults.
extern NSString *const kPSPDFLastUsedDrawingWidth; // float
extern NSString *const kPSPDFLastUsedColorForAnnotationType; // Dictionary NSString (annotation type) -> NSColor (encoded via NSKeyedArchiver)

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

/// Default/current drawing color (PSPDFAnnotationToolbarDraw).
/// Defaults to [UIColor colorWithRed:0.121f green:0.35f blue:1.f alpha:1.f]
/// PSPDFKit will save the last used drawing color in the NSUserDefaults.
@property (nonatomic, strong) UIColor *drawColor;

/// Current drawing line width. Defaults to 3.f
@property (nonatomic, assign) CGFloat lineWidth;

@end

@interface PSPDFAnnotationToolbar (PSPDFSubclassing)

/// Toolbar might be used "headless" but for state management. Manually call buttons here.
- (void)noteButtonPressed:(id)sender;
- (void)highlightButtonPressed:(id)sender;
- (void)strikeOutButtonPressed:(id)sender;
- (void)underlineButtonPressed:(id)sender;
- (void)drawButtonPressed:(id)sender;
- (void)doneButtonPressed:(id)sender;

// Only allowed during toolbarMode == PSPDFAnnotationToolbarDraw.
- (void)cancelDrawingAnimated:(BOOL)animated;
- (void)doneDrawingAnimated:(BOOL)animated;
- (void)undoDrawing:(id)sender;
- (void)redoDrawing:(id)sender;

// Finish up drawing. Usually called by the drawing delegate.
- (void)finishDrawingAnimated:(BOOL)animated andSaveAnnotation:(BOOL)saveAnnotation;

// helpers to lock/unlock the controller
- (void)lockPDFController;

// stayOnTop is a runtime tweak to make sure the toolbar stays above the pfController navigationBar.
- (void)unlockPDFControllerAndEnsureToStayOnTop:(BOOL)stayOnTop;

@end
