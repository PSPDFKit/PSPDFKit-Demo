//
//  PSPDFAnnotationToolbar.h
//  PSPDFKit
//
//  Copyright (c) 2012-2013 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY AUSTRIAN COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.
//

#import "PSPDFKitGlobal.h"
#import "PSPDFDrawView.h"
#import "PSPDFLineHelper.h"
#import "PSPDFSelectionView.h"

@class PSPDFViewController, PSPDFAnnotationToolbar;

// Animation notifications.
extern NSString *const PSPDFAnnotationToolbarWillHideNotification;

// Special type of "annotation" that will add an eraser feature to the toolbar.
extern NSString *const PSPDFAnnotationStringEraser;

// Special type that will add a selection tool to the toolbar.
extern NSString *const PSPDFAnnotationStringSelectionTool;

// Special type that will show a view controller with saved/precreated annotations.
// Currently this will also require PSPDFAnnotationStringStamp to be displayed.
extern NSString *const PSPDFAnnotationStringSavedAnnotations;

/// Delegate to be notified on toolbar actions/hiding.
@protocol PSPDFAnnotationToolbarDelegate <NSObject>

@optional

/// The annotation toolbar will be displayed.
- (void)annotationToolbarWillShow:(PSPDFAnnotationToolbar *)annotationToolbar;

/// The annotation toolbar has been displayed.
- (void)annotationToolbarDidShow:(PSPDFAnnotationToolbar *)annotationToolbar;

/// Called when the Done button has been pressed to hide the toolbar.
- (void)annotationToolbarWillHide:(PSPDFAnnotationToolbar *)annotationToolbar;

/// Called when the Done button has been pressed to hide the toolbar.
- (void)annotationToolbarDidHide:(PSPDFAnnotationToolbar *)annotationToolbar;

/// Called after a mode change is set (button pressed; drawing finished, etc)
- (void)annotationToolbar:(PSPDFAnnotationToolbar *)annotationToolbar didChangeMode:(NSString *)newMode;

@end

/// The annotation toolbar allows creation of most annotation types supported by PSPDFKit.
/// @note This class does a lot of state management, so you might also just use it in a headless state calling down to the various action methods expoxed in the SubclassingHooks category.
/// To customize which annotation icons should be displayed, edit `editableAnnotationTypes` in PSPDFDocument.
@interface PSPDFAnnotationToolbar : UIToolbar <PSPDFDrawViewDelegate, PSPDFSelectionViewDelegate>

/// Designated initializer.
- (id)initWithPDFController:(PSPDFViewController *)pdfController;

/// Show the toolbar in target rect. Rect should be the same height as the toolbar. (44px)
/// You need to manually add the toolbar to the view. This is just to get the animation right.
- (void)showToolbarInRect:(CGRect)rect animated:(BOOL)animated;

/// Hide the toolbar.
/// You need to manually remove the toolbar from the view in the completion block, if the finished parameter is set to YES.
/// This is just to get the animation right.
/// @warning This will restore the HUDViewMode that was set when showToolbarInRect:animated: has been called.
- (void)hideToolbarAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completionBlock;

/// Flashes the toolbar red (e.g. if user tries to hide the HUD.)
- (void)flashToolbar;

/// Annotation toolbar delegate. (Can be freely set to any receiver)
@property (nonatomic, weak) IBOutlet id<PSPDFAnnotationToolbarDelegate> annotationToolbarDelegate;

/// Attached pdfController.
/// @note If you update tintColor, barStyle, etc - this needs to be set again to re-capture changed states.
@property (nonatomic, weak) PSPDFViewController *pdfController;

/// Active annotation toolbar mode. Mode is an annotation type, e.g. PSPDFAnnotationStringHighlight.
/// @note Setting a toolbar mode will temporarily disable the long press gesture recognizer on the PSPDFScrollView to disable the new annotation menu.
@property (nonatomic, copy) NSString *toolbarMode;

/// Default/current drawing color (PSPDFAnnotationToolbarModeDraw, PSPDFAnnotationToolbarModeRectangle, PSPDFAnnotationToolbarModeEllipse, PSPDFAnnotationToolbarModeLine, PSPDFAnnotationToolbarModePolygon, PSPDFAnnotationToolbarModePolyLine).
/// Defaults to [UIColor colorWithRed:0.121f green:0.35f blue:1.f alpha:1.f]
/// @note PSPDFKit will save the last used drawing color in the NSUserDefaults.
@property (nonatomic, strong) UIColor *drawColor;

/// Default/current fill color (PSPDFAnnotationToolbarModeDraw, PSPDFAnnotationToolbarModeRectangle, PSPDFAnnotationToolbarModeEllipse, PSPDFAnnotationToolbarModeLine, PSPDFAnnotationToolbarModePolygon, PSPDFAnnotationToolbarModePolyLine).
/// Defaults to nil.
/// @note PSPDFKit will save the last used fill color in the NSUserDefaults.
@property (nonatomic, strong) UIColor *fillColor;

/// Current drawing line width. Defaults to 3.f
@property (nonatomic, assign) CGFloat lineWidth;

/// Starting line end type for lines and polylines.
@property (nonatomic, assign) PSPDFLineEndType lineEnd1;

/// Ending line end type for lines and polylines.
@property (nonatomic, assign) PSPDFLineEndType lineEnd2;

/// Font name for free text annotations.
@property (nonatomic, copy) NSString *fontName;

/// Font size for free text annotations.
@property (nonatomic, assign) CGFloat fontSize;

/// Text alignment for free text annotations.
@property (nonatomic, assign) NSTextAlignment textAlignment;

/// Enable to auto-hide toolbar after drawing finishes. Defaults to NO.
@property (nonatomic, assign) BOOL hideAfterDrawingDidFinish;

/// This will issue a save event after the toolbar has been dismissed.
/// @note Since saving can take some time, this defaults to NO.
@property (nonatomic, assign) BOOL saveAfterToolbarHiding;

/// Enable to cause the toolbar to fade in and out. Defaults to YES.
@property (nonatomic, assign) BOOL fadeToolbar;

/// Enable to cause the toolbar to slide into place. Defaults to YES.
/// @warning Only effective if fadeToolbar is set to YES.
@property (nonatomic, assign) BOOL slideToolbar;

/// Advanced property that allows you to customize how ink annotations are created.
/// Set to NO to cause separate ink drawings in the same drawing session to result in separate ink annotations. Defaults to YES.
@property (nonatomic, assign) BOOL combineInk;

// Dictionary keys for annotation groups
extern NSString *const PSPDFAnnotationGroupKeyChoice;
extern NSString *const PSPDFAnnotationGroupKeyGroup;

/// Annotations are grouped by default. Set to nil to disable grouping.
/// Groups are defined as dictionaries containing arrays of editableAnnotationType-objects, paired with an index indicating the current choice within each array.
/// Annotation types that are defined in the group but are missing in the `editableAnnotationTypes` will be ignored silently.
/// Use `PSPDFAnnotationGroupKeyChoice` and `PSPDFAnnotationGroupKeyGroup` as constants to configure the array.
@property (nonatomic, copy) NSArray *annotationGroups;

/// Allows custom `UIBarButtonItem` objects to be added after the buttons in `annotationGroups`. Defaults to nil.
/// @note Do not insert space objects - this is managed by PSPDFKit.
@property (nonatomic, copy) NSArray *additionalBarButtonItems;

@end

@interface PSPDFAnnotationToolbar (SubclassingHooks)

// Load the buttons into the drawing toolbar.
- (void)showDrawingToolbarWithMode:(NSString *)mode;

// Toolbar might be used "headless" but for state management. Manually call buttons here.
- (void)textButtonPressed:(id)sender; // Note
- (void)highlightButtonPressed:(id)sender;
- (void)strikeoutButtonPressed:(id)sender;
- (void)underlineButtonPressed:(id)sender;
- (void)squigglyButtonPressed:(id)sender;
- (void)inkButtonPressed:(id)sender;
- (void)squareButtonPressed:(id)sender;
- (void)circleButtonPressed:(id)sender;
- (void)lineButtonPressed:(id)sender;
- (void)polygonButtonPressed:(id)sender;
- (void)polylineButtonPressed:(id)sender;
- (void)freetextButtonPressed:(id)sender;
- (void)signatureButtonPressed:(id)sender;
- (void)stampButtonPressed:(id)sender;
- (void)imageButtonPressed:(id)sender;
- (void)soundButtonPressed:(id)sender;
- (void)eraserButtonPressed:(id)sender;
- (void)selectiontoolButtonPressed:(id)sender;
- (void)doneButtonPressed:(id)sender NS_REQUIRES_SUPER;

// Only allowed during toolbar drawing mode (ink, line, polyline, polygon, circle, ellipse)
- (void)cancelDrawingAnimated:(BOOL)animated;
- (void)doneDrawingAnimated:(BOOL)animated;
- (void)selectStrokeColor:(id)sender;
- (void)undoDrawing:(id)sender;
- (void)redoDrawing:(id)sender;

// While we're in drawing mode, undo/redo has a different state.
- (void)updateDrawingUndoRedoButtons NS_REQUIRES_SUPER; // Called when the button states are changed.
- (BOOL)canUndoDrawing; // YES if we can undo drawing
- (BOOL)canRedoDrawing; // YES if we can redo drawing

// Called each time the toolbar items are re-set.
- (void)updateToolbarButtonsAnimated:(BOOL)animated;

/// Return the number of buttons allowed in the toolbar.
- (NSUInteger)allowedButtonCount;

// Called anytime the drawing toolbar is taken down.
- (void)hideAndRemoveToolbar;

// Color management.
- (void)setLastUsedColor:(UIColor *)lastUsedDrawColor forAnnotationType:(NSString *)annotationType;
- (UIColor *)lastUsedColorForAnnotationTypeString:(NSString *)annotationType;

// Finish up drawing. Usually called by the drawing delegate.
- (void)finishDrawingAnimated:(BOOL)animated saveAnnotation:(BOOL)saveAnnotation;

// Allows to override and hook into to create custom annotations.
- (NSArray *)annotationsWithActionList:(NSArray *)actionList bounds:(CGRect)bounds page:(NSUInteger)page;

// Parses the editableAnnotationTypes set from the document.
// Per default this is the contents of the editableAnnotationTypes set in PSPDFDocument.
// If set to nil, this will load from pdfController.document.editableAnnotationTypes.allObjects.
@property (nonatomic, copy) NSOrderedSet *editableAnnotationTypes;

// If we're in drawing mode, this dictionary contains the PSPDFDrawView classes that are overlayed on the PSPDFPageView.
// The key is the current page.
@property (nonatomic, strong, readonly) NSDictionary *drawViews;

@end
