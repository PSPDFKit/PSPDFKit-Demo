//
//  PSPDFAnnotationToolbar.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 Peter Steinberger. All rights reserved.
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
    PSPDFAnnotationToolbarDraw,
    PSPDFAnnotationToolbarRectangle,
    PSPDFAnnotationToolbarEllipse,
    PSPDFAnnotationToolbarLine,
    PSPDFAnnotationToolbarSignature,
    PSPDFAnnotationToolbarStamp,
    PSPDFAnnotationToolbarImage,
};

/// Delegate to be notified on toolbar actions/hiding.
@protocol PSPDFAnnotationToolbarDelegate <NSObject>

@optional

/// Called when the Done button has been pressed to hide the toolbar.
- (void)annotationToolbarDidHide:(PSPDFAnnotationToolbar *)annotationToolbar;

/// Called after a mode change is set (button pressed; drawing finished, etc)
- (void)annotationToolbar:(PSPDFAnnotationToolbar *)annotationToolbar didChangeMode:(PSPDFAnnotationToolbarMode)newMode;

@end

// constants which are used for NSUserDefaults.
extern NSString *const kPSPDFLastUsedDrawingWidth; // float
extern NSString *const kPSPDFLastUsedColorForAnnotationType; // Dictionary NSString (annotation type) -> NSColor (encoded via NSKeyedArchiver)

/**
 Toolbar to quickly create annotations.

 This is just one way to create annotations. They can also be created in code, but PSPDFAnnotationToolbar does a lot of work/view/state management for you - if you implement your own annotation UI, you should still use PSPDFAnnotationToolbar underneath (just don't show it, but call the methods).

 To customize which annotation icons should be displayed, simply edit editableAnnotationTypes in PSPDFDocument.
 */
@interface PSPDFAnnotationToolbar : UIToolbar <PSPDFDrawViewDelegate, PSPDFSelectionViewDelegate>

/// Designated initializer.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// Show the toolbar in target rect. Rect should be the same height as the toolbar. (44px)
/// You need to manually add the toolbar to the view. This is just to get the animation right.
- (void)showToolbarInRect:(CGRect)rect animated:(BOOL)animated;

/// Hide the toolbar.
/// You need to manually remove the toolbar from the view in the completion block. This is just to get the animation right.
/// @warning This will restore the HUDViewMode that was set when showToolbarInRect:animated: has been called.
- (void)hideToolbarAnimated:(BOOL)animated completion:(dispatch_block_t)completionBlock;

/// Flash toolbar (e.g. if user tries to hide the HUD)
- (void)flashToolbar;

/// Annotation toolbar delegate. (Can be freely set to any receiver)
@property (nonatomic, weak) IBOutlet id<PSPDFAnnotationToolbarDelegate> delegate;

/// Attached pdfController.
/// If you update tintColor, barStyle, etc - this needs to be set again to re-capture changed states.
@property (nonatomic, weak) PSPDFViewController *pdfController;

/// Active annotation toolbar mode.
/// @note Setting a toolbar mode will temporarily disable the long press gesture recognizer on the PSPDFScrollView to disable the new annotation menu.
@property (nonatomic, assign) PSPDFAnnotationToolbarMode toolbarMode;

/// Default/current drawing color (PSPDFAnnotationToolbarDraw, PSPDFAnnotationToolbarRectangle, PSPDFAnnotationToolbarEllipse, PSPDFAnnotationToolbarLine).
/// Defaults to [UIColor colorWithRed:0.121f green:0.35f blue:1.f alpha:1.f]
/// PSPDFKit will save the last used drawing color in the NSUserDefaults.
@property (nonatomic, strong) UIColor *drawColor;

/// Current drawing line width. Defaults to 3.f
@property (nonatomic, assign) CGFloat lineWidth;

/// Enable to auto-hide toolbar after drawing finishes. Defaults to NO.
@property (nonatomic, assign) BOOL hideAfterDrawingDidFinish;

/// This will issue a save event after the toolbar has been dismissed.
/// Since saving is slow, this defaults to NO.
@property (nonatomic, assign) BOOL saveAfterToolbarHiding;

/// Enable to cause the toolbar to fade in and out. Defaults to YES.
@property (nonatomic, assign) BOOL fadeToolbar;

/// Enable to cause the toolbar to slide into place. Defaults to YES.
/// @warning Only effective if fadeToolbar is set to YES.
@property (nonatomic, assign) BOOL slideToolbar;

/// Allows to scroll with two fingers while annotation mode is active. Defaults to NO.
/// Not all annotation modes block scrolling (but highlight, drawing, etc. do).
/// @warning Do not change this while we are in annotation mode.
@property (nonatomic, assign) BOOL allowTwoFingerScrollPanDuringLock;

@end

@interface PSPDFAnnotationToolbar (PSPDFSubclassing)

// Toolbar might be used "headless" but for state management. Manually call buttons here.
- (void)noteButtonPressed:(id)sender;
- (void)highlightButtonPressed:(id)sender;
- (void)strikeOutButtonPressed:(id)sender;
- (void)underlineButtonPressed:(id)sender;
// Draw replaces the toolbar items with custom items and later restores the original items via using the 'originalItems' property.
- (void)drawButtonPressed:(id)sender;
- (void)rectangleButtonPressed:(id)sender;
- (void)ellipseButtonPressed:(id)sender;
- (void)lineButtonPressed:(id)sender;
- (void)freeTextButtonPressed:(id)sender;
- (void)signatureButtonPressed:(id)sender;
- (void)stampButtonPressed:(id)sender;
- (void)imageButtonPressed:(id)sender;
- (void)doneButtonPressed:(id)sender;

// Only allowed during toolbarMode == PSPDFAnnotationToolbarDraw, PSPDFAnnotationToolbarRectangle, PSPDFAnnotationToolbarEllipse, PSPDFAnnotationToolbarLine.
- (void)cancelDrawingAnimated:(BOOL)animated;
- (void)doneDrawingAnimated:(BOOL)animated;
- (void)selectStrokeColor:(id)sender;
- (void)undoDrawing:(id)sender;
- (void)redoDrawing:(id)sender;

// Called anytime the drawing toolbar is updated.
- (void)updateDrawingToolbar;
@property (nonatomic, strong, readonly) UIBarButtonItem *undoItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *redoItem;

// Drawing mode will update the toolbar items, here are the original items saved.
@property (nonatomic, copy, readonly) NSArray *originalItems;

// Color management.
- (void)setLastUsedColor:(UIColor *)lastUsedDrawColor forAnnotationType:(NSString *)annotationType;
- (UIColor *)lastUsedColorForAnnotationTypeString:(NSString *)annotationType;

// Finish up drawing. Usually called by the drawing delegate.
- (void)finishDrawingAnimated:(BOOL)animated andSaveAnnotation:(BOOL)saveAnnotation;

// Helpers to lock/unlock the controller
- (void)lockPDFControllerAnimated:(BOOL)animated;

// stayOnTop is a runtime tweak to make sure the toolbar stays above the pdfController navigationBar.
- (void)unlockPDFControllerAnimated:(BOOL)animated showControls:(BOOL)showControls ensureToStayOnTop:(BOOL)stayOnTop;

// Parses the editableAnnotationTypes set from the document.
// Per default this is the contents of the editableAnnotationTypes set in PSPDFDocument.
// If set to nil, this will load from pdfController.document.editableAnnotationTypes.allObjects.
@property (nonatomic, copy) NSOrderedSet *editableAnnotationTypes;

@end
